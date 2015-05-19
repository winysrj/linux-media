Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:50806 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbbESWGp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 18:06:45 -0400
Date: Tue, 19 May 2015 23:36:27 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] ir-keytable: allow protocol for scancode-keycode
 mappings
Message-ID: <20150519213627.GH18036@hardeman.nu>
References: <20150406112326.23289.28902.stgit@zeus.muc.hardeman.nu>
 <20150406112618.23289.95433.stgit@zeus.muc.hardeman.nu>
 <20150514182446.4f21a594@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150514182446.4f21a594@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 14, 2015 at 06:24:46PM -0300, Mauro Carvalho Chehab wrote:
>Em Mon, 06 Apr 2015 13:26:18 +0200
>David Härdeman <david@hardeman.nu> escreveu:
>
>> Introduce a list of "kernel" ir protocols (e.g. "sony12" instead of "sony")
>> and extend the set-key command to ir-keytable to allow for a mapping of the
>> form "protocol:scancode=keycode" in addition to the old "scancode=keycode"
>> format. The code automatically falls back to the old behaviour if the
>> kernel doesn't support the new approach with protocols.
>> 
>> The read command is also updated to show the protocol information if the
>> kernel supports it.
>
>
>I applied patches 1 to 3 of this series, as they are not based on any
>new feature.
>
>This patch, however, needs to wait for the Kernel patch to be acked, and
>may be modified, depending on the review process.
>
>I'll mark it at patchwork as RFC. Please re-submit after we merge the
>Kernel changes.

Agreed :)

>
>Thanks,
>Mauro
>
>> 
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>> ---
>>  utils/keytable/keytable.c |  288 ++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 202 insertions(+), 86 deletions(-)
>> 
>> diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
>> index 63eea2e..fd50095 100644
>> --- a/utils/keytable/keytable.c
>> +++ b/utils/keytable/keytable.c
>> @@ -55,13 +55,22 @@ struct input_keymap_entry_v2 {
>>  #define EVIOCSKEYCODE_V2	_IOW('E', 0x04, struct input_keymap_entry_v2)
>>  #endif
>>  
>> -struct keytable_entry {
>> -	u_int32_t scancode;
>> -	u_int32_t keycode;
>> -	struct keytable_entry *next;
>> +struct rc_scancode {
>> +	u_int16_t protocol;
>> +	u_int16_t reserved[3];
>> +	u_int64_t scancode;
>>  };
>>  
>> -struct keytable_entry *keytable = NULL;
>> +struct rc_keymap_entry {
>> +	u_int8_t  flags;
>> +	u_int8_t  len;
>> +	u_int16_t index;
>> +	u_int32_t keycode;
>> +	union {
>> +		struct rc_scancode rc;
>> +		u_int8_t raw[32];
>> +	};
>> +};
>>  
>>  struct uevents {
>>  	char		*key;
>> @@ -109,41 +118,76 @@ enum sysfs_protocols {
>>  	SYSFS_INVALID		= 0,
>>  };
>>  
>> +enum kernel_protocol {
>> +	KERN_UNKNOWN		= 0,    /* Protocol not known */
>> +	KERN_OTHER		= 1,    /* Protocol known but proprietary */
>> +	KERN_LIRC		= 2,    /* Pass raw IR to lirc userspace */
>> +	KERN_RC5		= 3,    /* Philips RC5 protocol */
>> +	KERN_RC5X		= 4,    /* Philips RC5x protocol */
>> +	KERN_RC5_SZ		= 5,    /* StreamZap variant of RC5 */
>> +	KERN_JVC		= 6,    /* JVC protocol */
>> +	KERN_SONY12		= 7,    /* Sony 12 bit protocol */
>> +	KERN_SONY15		= 8,    /* Sony 15 bit protocol */
>> +	KERN_SONY20		= 9,    /* Sony 20 bit protocol */
>> +	KERN_NEC		= 10,   /* NEC protocol */
>> +	KERN_SANYO		= 11,   /* Sanyo protocol */
>> +	KERN_MCE_KBD		= 12,   /* RC6-ish MCE keyboard/mouse */
>> +	KERN_RC6_0		= 13,   /* Philips RC6-0-16 protocol */
>> +	KERN_RC6_6A_20		= 14,   /* Philips RC6-6A-20 protocol */
>> +	KERN_RC6_6A_24		= 15,   /* Philips RC6-6A-24 protocol */
>> +	KERN_RC6_6A_32		= 16,   /* Philips RC6-6A-32 protocol */
>> +	KERN_RC6_MCE		= 17,   /* MCE (Philips RC6-6A-32 subtype) protocol */
>> +	KERN_SHARP		= 18,   /* Sharp protocol */
>> +	KERN_XMP		= 19,   /* XMP protocol */
>> +	KERN_INVALID		= 31,	/* internal, no real protocol number */
>> +};
>> +
>>  struct protocol_map_entry {
>>  	const char *name;
>>  	const char *sysfs1_name;
>>  	enum sysfs_protocols sysfs_protocol;
>> +	enum kernel_protocol kernel_protocol;
>>  };
>>  
>>  const struct protocol_map_entry protocol_map[] = {
>> -	{ "unknown",	NULL,		SYSFS_UNKNOWN	},
>> -	{ "other",	NULL,		SYSFS_OTHER	},
>> -	{ "lirc",	NULL,		SYSFS_LIRC	},
>> -	{ "rc-5",	"/rc5_decoder",	SYSFS_RC5	},
>> -	{ "rc5",	NULL,		SYSFS_RC5	},
>> -	{ "rc-5x",	NULL,		SYSFS_INVALID	},
>> -	{ "rc5x",	NULL,		SYSFS_INVALID	},
>> -	{ "jvc",	"/jvc_decoder",	SYSFS_JVC	},
>> -	{ "sony",	"/sony_decoder",SYSFS_SONY	},
>> -	{ "sony12",	NULL,		SYSFS_INVALID	},
>> -	{ "sony15",	NULL,		SYSFS_INVALID	},
>> -	{ "sony20",	NULL,		SYSFS_INVALID	},
>> -	{ "nec",	"/nec_decoder",	SYSFS_NEC	},
>> -	{ "sanyo",	NULL,		SYSFS_SANYO	},
>> -	{ "mce-kbd",	NULL,		SYSFS_MCE_KBD	},
>> -	{ "mce_kbd",	NULL,		SYSFS_MCE_KBD	},
>> -	{ "rc-6",	"/rc6_decoder",	SYSFS_RC6	},
>> -	{ "rc6",	NULL,		SYSFS_RC6	},
>> -	{ "rc-6-0",	NULL,		SYSFS_INVALID	},
>> -	{ "rc-6-6a-20",	NULL,		SYSFS_INVALID	},
>> -	{ "rc-6-6a-24",	NULL,		SYSFS_INVALID	},
>> -	{ "rc-6-6a-32",	NULL,		SYSFS_INVALID	},
>> -	{ "rc-6-mce",	NULL,		SYSFS_INVALID	},
>> -	{ "sharp",	NULL,		SYSFS_SHARP	},
>> -	{ "xmp",	"/xmp_decoder",	SYSFS_XMP	},
>> -	{ NULL,		NULL,		SYSFS_INVALID	},
>> +	{ "unknown",	NULL,		SYSFS_UNKNOWN,	KERN_UNKNOWN	},
>> +	{ "other",	NULL,		SYSFS_OTHER,	KERN_OTHER	},
>> +	{ "lirc",	NULL,		SYSFS_LIRC,	KERN_LIRC	},
>> +	{ "rc-5",	"/rc5_decoder",	SYSFS_RC5,	KERN_RC5	},
>> +	{ "rc5",	NULL,		SYSFS_RC5,	KERN_RC5	},
>> +	{ "rc-5x",	NULL,		SYSFS_INVALID,	KERN_RC5X	},
>> +	{ "rc5x",	NULL,		SYSFS_INVALID,	KERN_RC5X	},
>> +	{ "jvc",	"/jvc_decoder",	SYSFS_JVC,	KERN_JVC	},
>> +	{ "sony",	"/sony_decoder",SYSFS_SONY,	KERN_INVALID	},
>> +	{ "sony12",	NULL,		SYSFS_INVALID,	KERN_SONY12	},
>> +	{ "sony15",	NULL,		SYSFS_INVALID,	KERN_SONY15	},
>> +	{ "sony20",	NULL,		SYSFS_INVALID,	KERN_SONY20	},
>> +	{ "nec",	"/nec_decoder",	SYSFS_NEC,	KERN_NEC	},
>> +	{ "sanyo",	NULL,		SYSFS_SANYO,	KERN_SANYO	},
>> +	{ "mce-kbd",	NULL,		SYSFS_MCE_KBD,	KERN_MCE_KBD	},
>> +	{ "mce_kbd",	NULL,		SYSFS_MCE_KBD,	KERN_MCE_KBD	},
>> +	{ "rc-6",	"/rc6_decoder",	SYSFS_RC6,	KERN_INVALID	},
>> +	{ "rc6",	NULL,		SYSFS_RC6,	KERN_INVALID 	},
>> +	{ "rc-6-0",	NULL,		SYSFS_INVALID,	KERN_RC6_0	},
>> +	{ "rc-6-6a-20",	NULL,		SYSFS_INVALID,	KERN_RC6_6A_20	},
>> +	{ "rc-6-6a-24",	NULL,		SYSFS_INVALID,	KERN_RC6_6A_24	},
>> +	{ "rc-6-6a-32",	NULL,		SYSFS_INVALID,	KERN_RC6_6A_32	},
>> +	{ "rc-6-mce",	NULL,		SYSFS_INVALID,	KERN_RC6_MCE	},
>> +	{ "sharp",	NULL,		SYSFS_SHARP,	KERN_SHARP	},
>> +	{ "xmp",	"/xmp_decoder",	SYSFS_XMP,	KERN_XMP	},
>> +	{ NULL,		NULL,		SYSFS_INVALID,	KERN_INVALID	},
>> +};
>> +
>> +struct keytable_entry {
>> +	u_int32_t scancode;
>> +	u_int32_t keycode;
>> +	enum kernel_protocol protocol;
>> +	struct keytable_entry *next;
>>  };
>>  
>> +struct keytable_entry *keytable = NULL;
>> +
>> +
>>  static enum sysfs_protocols parse_sysfs_protocol(const char *name, bool all_allowed)
>>  {
>>  	const struct protocol_map_entry *pme;
>> @@ -162,6 +206,21 @@ static enum sysfs_protocols parse_sysfs_protocol(const char *name, bool all_allo
>>  	return SYSFS_INVALID;
>>  }
>>  
>> +static enum kernel_protocol parse_kernel_protocol(const char *name)
>> +{
>> +	const struct protocol_map_entry *pme;
>> +
>> +	if (!name)
>> +		return KERN_INVALID;
>> +
>> +	for (pme = protocol_map; pme->name; pme++) {
>> +		if (!strcasecmp(name, pme->name))
>> +			return pme->kernel_protocol;
>> +	}
>> +
>> +	return KERN_INVALID;
>> +}
>> +
>>  static void write_sysfs_protocols(enum sysfs_protocols protocols, FILE *fp, const char *fmt)
>>  {
>>  	const struct protocol_map_entry *pme;
>> @@ -197,6 +256,7 @@ static const char doc[] = N_(
>>  	"  SYSDEV   - the ir class as found at /sys/class/rc\n"
>>  	"  TABLE    - a file with a set of scancode=keycode value pairs\n"
>>  	"  SCANKEY  - a set of scancode1=keycode1,scancode2=keycode2.. value pairs\n"
>> +	"             or (experimentally) a list of protocol1:scancode1=keycode1,protocol2:scancode2=keycode2...triplets\n"
>>  	"  PROTOCOL - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc,\n"
>>  	"                            sharp, mce_kbd, xmp, other, all) to be enabled\n"
>>  	"  DELAY    - Delay before repeating a keystroke\n"
>> @@ -447,7 +507,6 @@ err_einval:
>>  static error_t parse_opt(int k, char *arg, struct argp_state *state)
>>  {
>>  	char *p;
>> -	long key;
>>  	int rc;
>>  
>>  	switch (k) {
>> @@ -492,51 +551,69 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
>>  		break;
>>  	}
>>  	case 'k':
>> -		p = strtok(arg, ":=");
>> -		do {
>> +		for (p = strtok(arg, ",;"); p; p = strtok(NULL, ",;")) {
>> +			char *protocol_str;
>> +			enum kernel_protocol protocol = KERN_INVALID;
>> +			long long int scancode;
>> +			char *keycode_str;
>> +			long keycode;
>>  			struct keytable_entry *ke;
>>  
>> -			if (!p)
>> -				goto err_inval;
>> -
>> -			ke = calloc(1, sizeof(*ke));
>> -			if (!ke) {
>> -				perror(_("No memory!\n"));
>> -				return ENOMEM;
>> +			errno = 0;
>> +			/* New format - protocol:scancode=keycode */
>> +			if (sscanf(p, " %m[^:] : %lli = %ms", &protocol_str, &scancode, &keycode_str) != 3) {
>> +			       if (errno != 0) {
>> +				       fprintf(stderr, _("sscanf failed!\n"));
>> +				       return errno;
>> +			       }
>> +
>> +			       /* Old format - scancode=keycode */
>> +			       protocol_str = NULL;
>> +			       if (sscanf(p, " %lli = %ms", &scancode, &keycode_str) != 2) {
>> +				       if (errno != 0) {
>> +					       fprintf(stderr, _("sscanf failed!\n"));
>> +					       return errno;
>> +				       }
>> +				       goto err_inval;
>> +			       }
>>  			}
>>  
>> -			ke->scancode = strtoul(p, NULL, 0);
>> -			if (errno) {
>> -				free(ke);
>> -				goto err_inval;
>> +			keycode = parse_code(keycode_str);
>> +			if (keycode == -1) {
>> +				errno = 0;
>> +				keycode = strtoul(keycode_str, NULL, 0);
>> +				if (errno)
>> +					keycode = -1;
>>  			}
>> +			free(keycode_str);
>>  
>> -			p = strtok(NULL, ",;");
>> -			if (!p) {
>> -				free(ke);
>> -				goto err_inval;
>> -			}
>> +			if (protocol_str) {
>> +				protocol = parse_kernel_protocol(protocol_str);
>> +				free(protocol_str);
>>  
>> -			key = parse_code(p);
>> -			if (key == -1) {
>> -				key = strtol(p, NULL, 0);
>> -				if (errno) {
>> -					free(ke);
>> +				if (protocol == KERN_INVALID)
>>  					goto err_inval;
>> -				}
>>  			}
>>  
>> -			ke->keycode = key;
>> +			if (keycode == -1 || scancode < 0)
>> +				goto err_inval;
>>  
>> -			if (debug)
>> -				fprintf(stderr, _("scancode 0x%04x=%u\n"),
>> -					ke->scancode, ke->keycode);
>> +			ke = calloc(1, sizeof(*ke));
>> +			if (!ke) {
>> +				perror(_("No memory!\n"));
>> +				return ENOMEM;
>> +			}
>>  
>> +			ke->scancode = scancode;
>> +			ke->keycode = keycode;
>> +			ke->protocol = protocol;
>>  			ke->next = keytable;
>>  			keytable = ke;
>>  
>> -			p = strtok(NULL, ":=");
>> -		} while (p);
>> +			if (debug)
>> +				fprintf(stderr, _("scancode %i:0x%04x=%u\n"),
>> +					ke->protocol, ke->scancode, ke->keycode);
>> +		}
>>  		break;
>>  	case 'p':
>>  		for (p = strtok(arg, ",;"); p; p = strtok(NULL, ",;")) {
>> @@ -579,21 +656,24 @@ static struct argp argp = {
>>  	.doc = doc,
>>  };
>>  
>> -static void prtcode(int *codes)
>> +static void print_mapping(enum kernel_protocol protocol, unsigned scancode, unsigned keycode)
>>  {
>>  	struct parse_event *p;
>>  
>> +	if (protocol != KERN_INVALID)
>> +		printf(_("protocol 0x%04x, "), protocol);
>> +
>>  	for (p = key_events; p->name != NULL; p++) {
>> -		if (p->value == (unsigned)codes[1]) {
>> -			printf(_("scancode 0x%04x = %s (0x%02x)\n"), codes[0], p->name, codes[1]);
>> +		if (p->value == keycode) {
>> +			printf(_("scancode 0x%04x = %s (0x%02x)\n"), scancode, p->name, keycode);
>>  			return;
>>  		}
>>  	}
>>  
>> -	if (isprint (codes[1]))
>> -		printf(_("scancode 0x%04x = '%c' (0x%02x)\n"), codes[0], codes[1], codes[1]);
>> +	if (isprint(keycode))
>> +		printf(_("scancode 0x%04x = '%c' (0x%02x)\n"), scancode, keycode, keycode);
>>  	else
>> -		printf(_("scancode 0x%04x = 0x%02x\n"), codes[0], codes[1]);
>> +		printf(_("scancode 0x%04x = 0x%02x\n"), scancode, keycode);
>>  }
>>  
>>  static void free_names(struct sysfs_names *names)
>> @@ -1201,12 +1281,30 @@ static int add_keys(int fd)
>>  	int write_cnt = 0;
>>  	struct keytable_entry *ke;
>>  	unsigned codes[2];
>> +	struct rc_keymap_entry rke;
>>  
>>  	for (ke = keytable; ke; ke = ke->next) {
>>  		write_cnt++;
>>  		if (debug)
>> -			fprintf(stderr, "\t%04x=%04x\n",
>> -				ke->scancode, ke->keycode);
>> +			fprintf(stderr, "\t%u:%04x=%04x\n",
>> +				ke->protocol, ke->scancode, ke->keycode);
>> +
>> +		if (ke->protocol != KERN_INVALID) {
>> +			memset(&rke, '\0', sizeof(rke));
>> +			rke.len = sizeof(rke.rc);
>> +			rke.keycode = ke->keycode;
>> +			rke.rc.protocol = ke->protocol;
>> +			rke.rc.scancode = ke->scancode;
>> +
>> +			if (debug)
>> +				fprintf(stderr, _("Attempting new EVIOCSKEYCODE_V2 ioctl\n"));
>> +
>> +			if (ioctl(fd, EVIOCSKEYCODE_V2, &rke) == 0)
>> +				continue;
>> +
>> +			if (debug)
>> +				fprintf(stderr, _("New EVIOCSKEYCODE_V2 ioctl failed\n"));
>> +		}
>>  
>>  		codes[0] = ke->scancode;
>>  		codes[1] = ke->keycode;
>> @@ -1329,7 +1427,7 @@ static void display_table_v1(struct rc_device *rc_dev, int fd)
>>  			if (ioctl(fd, EVIOCGKEYCODE, codes) == -1)
>>  				perror("EVIOCGKEYCODE");
>>  			else if (codes[1] != KEY_RESERVED)
>> -				prtcode(codes);
>> +				print_mapping(KERN_INVALID, codes[0], codes[1]);
>>  		}
>>  	}
>>  	display_proto(rc_dev);
>> @@ -1337,27 +1435,45 @@ static void display_table_v1(struct rc_device *rc_dev, int fd)
>>  
>>  static void display_table_v2(struct rc_device *rc_dev, int fd)
>>  {
>> +	struct input_keymap_entry_v2 ike;
>> +	struct rc_keymap_entry rke;
>> +	bool first = true, rke_supported = true;
>> +	u_int32_t scancode;
>>  	int i;
>> -	struct input_keymap_entry_v2 entry;
>> -	int codes[2];
>>  
>> -	memset(&entry, '\0', sizeof(entry));
>> -	i = 0;
>> -	do {
>> -		entry.flags = KEYMAP_BY_INDEX;
>> -		entry.index = i;
>> -		entry.len = sizeof(u_int32_t);
>> +	for (i = 0; ; i++) {
>> +		if (first || rke_supported) {
>> +			memset(&rke, '\0', sizeof(rke));
>> +			rke.flags = KEYMAP_BY_INDEX;
>> +			rke.index = i;
>> +			rke.len = sizeof(rke.rc);
>>  
>> -		if (ioctl(fd, EVIOCGKEYCODE_V2, &entry) == -1)
>> +			if (ioctl(fd, EVIOCGKEYCODE_V2, &rke) == -1) {
>> +				if (first)
>> +					rke_supported = false;
>> +				else
>> +					break;
>> +			}
>> +
>> +			first = false;
>> +			if (rke_supported) {
>> +				print_mapping(rke.rc.protocol, rke.rc.scancode, rke.keycode);
>> +				continue;
>> +			}
>> +		}
>> +
>> +		memset(&ike, '\0', sizeof(ike));
>> +		ike.flags = KEYMAP_BY_INDEX;
>> +		ike.index = i;
>> +		ike.len = sizeof(scancode);
>> +
>> +		if (ioctl(fd, EVIOCGKEYCODE_V2, &ike) == -1)
>>  			break;
>>  
>>  		/* FIXME: Extend it to support scancodes > 32 bits */
>> -		memcpy(&codes[0], entry.scancode, sizeof(codes[0]));
>> -		codes[1] = entry.keycode;
>> -
>> -		prtcode(codes);
>> -		i++;
>> -	} while (1);
>> +		memcpy(&scancode, ike.scancode, sizeof(scancode));
>> +		print_mapping(KERN_INVALID, scancode, ike.keycode);
>> +	}
>>  	display_proto(rc_dev);
>>  }
>>  
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
David Härdeman
