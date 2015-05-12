Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:60687 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932553AbbELOBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 10:01:39 -0400
Message-ID: <555207B6.7050005@xs4all.nl>
Date: Tue, 12 May 2015 16:01:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	emil.l.velikov@gmail.com
Subject: Re: [PATCH v3] libgencec: Add userspace library for the generic CEC
 kernel interface
References: <1430915838-20547-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430915838-20547-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

A quick review:

On 05/06/15 14:37, Kamil Debski wrote:
> new file mode 100644
> index 0000000..bb817b7
> --- /dev/null
> +++ b/README
> @@ -0,0 +1,22 @@
> +libGenCEC - library for the generic HDMI CEC kernel interface
> +--------------------------------------------------------------------------
> +
> +The libGenCEC library is a simple library that was written to facilitate
> +proper configuration and use of HDMI CEC devices that use the generic HDMI
> +CEC kernel interface.
> +
> +The library provides a range of functions that wrap around the ioctls of the
> +kernel API. It contains a test application that can be used to communicate
> +through the CEC bus with other compatible devices.
> +
> +The test application also serves as a code example on how to use the library.
> +
> +The library calls are documented in the gencec.h file.
> +
> +Example application use
> +--------------------------------------------------------------------------
> +The following command will initiate the devic, set the name and enable

devic -> device

> +keypress forwarding. Tested on a Samsung TV model LE32C650.
> +
> +./cectest -e -l playback -P -O Test123 -T -A -M on
> +

> diff --git a/examples/cectest.c b/examples/cectest.c

I think this should be in a utils directory and be called cec-ctl.
It's not just a test utility, like v4l2-ctl it can be used to control
the cec devices.

> new file mode 100644
> index 0000000..659f841
> --- /dev/null
> +++ b/examples/cectest.c
> @@ -0,0 +1,631 @@
> +/*
> + * Copyright 2015 Samsung Electronics Co. Ltd
> + *
> + * Licensed under the Apache License, Version 2.0 (the "License");
> + * you may not use this file except in compliance with the License.
> + * You may obtain a copy of the License at
> + *
> + *      http://www.apache.org/licenses/LICENSE-2.0
> + *
> + * Unless required by applicable law or agreed to in writing, software
> + * distributed under the License is distributed on an "AS IS" BASIS,
> + * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> + * See the License for the specific language governing permissions and
> + * limitations under the License.
> + */
> +
> +#include <gencec.h>
> +#include <getopt.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +/* A single entry in the list of tasks to be done */
> +struct todo {
> +	char cmd;
> +	char *param;
> +	struct todo *next;
> +};
> +
> +/* Print a help message with the list and the description of all commands */
> +void print_usage(char *name)
> +{
> +	printf("\nUsage:\n");
> +	printf("\t%s\n", name);
> +
> +	printf("General options:\n");
> +	printf("\t--help/-h - display this message\n");

I think this ' - ' is confusing as a separator. Take a look at v4l2-ctl --help and
how that aligns things. I think that is more readable (admittedly, I am biased!).

> +	printf("\t--device/-D <device name> - name of the CEC device (default is /dev/cec0)\n");
> +
> +	printf("CEC device related commands:\n");
> +	printf("\t--enable/-e - enable the CEC adapter\n");
> +	printf("\t--disable/-d - disable the CEC adapter\n");
> +	printf("\t--add-logical/-l <addr_type> - add logical address of given type\n");
> +	printf("\t\tTypes: tv, record, tuner, playback, audio, switch, videoproc\n");
> +	printf("\t--clear-logical/-c - clear logical addresses\n");
> +	printf("\t--get-logical/-G - get logical address(es)\n");
> +	printf("\t--get-physical/-g - get the physical address\n");
> +	printf("\t--set-physical/-s <addr> - set the physical address\n");
> +	printf("\t\t<addr> should be in the following format N.N.N.N where N is between 0 and 15\n");
> +	printf("\t\te.g. --set-physical 1.0.0.11\n");
> +	printf("\t--info/-i - print information about the CEC device\n");
> +	printf("\t--send/-S <addr>:<contents> - send a message to a specified address\n");
> +	printf("\t\t<addr> should be an integer ranging from 0 to 15 (where 15 is a broadcast address\n");
> +	printf("\t\t<contents> should be an array of hexadecimal bytes\n");
> +	printf("\t\te.g. --send 11:010b0cf6 which will send a message consisting of 010b0cf6 to\n");
> +	printf("\t\tthe device with logical address 11\n");
> +	printf("\t\t<contents> should be a hexadecimal number that represents the bytes to be sent\n");
> +	printf("\t--receive/-R - receive a single CEC message\n");
> +	printf("\t--passthrough/-p <state> - enable/disable passthrough mode\n");
> +
> +	printf("Useful CEC standard commands:\n");
> +	printf("\t--osd/-O <OSD name> - set the OSD name for device\n");
> +	printf("\t--give-power-status/-P <status> - give device power status\n");
> +	printf("\t--text-view-on/-T - Sent by a source device to the TV whenever it enters the active state \n");
> +	printf("\t--active-source/-A - indicate that it has started to transmit a stream\n");
> +	printf("\t--menu-state/-M <state> - used to indicate that the device is showing a menu (enable keycode forwarding)\n");
> +	printf("\t\t<state> = \"on\" or \"off\"\n");
> +	printf("\t\n");
> +	printf("\tCommands are executed in the order given in argument list.\n");
> +}
> +
> +/* Parse the arguments list and prepare a list with task that are to be done */
> +struct todo *parse_args(int argc, char **argv)
> +{
> +	struct todo *list = 0;
> +	struct todo *tmp;
> +
> +	int c;
> +	int option_index = 0;
> +
> +	static struct option long_options[] =
> +	{
> +		{"device",		required_argument,	0, 'D'},
> +		{"help",		no_argument,		0, 'h'},
> +
> +		{"enable",		no_argument,		0, 'e'},
> +		{"disable",		no_argument,		0, 'd'},
> +		{"add-logical",		required_argument,	0, 'l'},
> +		{"clear-logical",	no_argument,		0, 'c'},
> +		{"get-logical",		no_argument,		0, 'G'},
> +		{"get-physical",	no_argument,		0, 'g'},
> +		{"set-physical",	required_argument,	0, 's'},
> +		{"info",		no_argument,		0, 'i'},
> +		{"passthrough",		required_argument,	0, 'p'},
> +
> +		{"send",		required_argument,	0, 'S'},
> +		{"receive",		no_argument,		0, 'R'},
> +
> +		{"osd",			required_argument,	0, 'O'},
> +		{"give-power-status",	required_argument,	0, 'P'},
> +		{"text-view-on",	no_argument,		0, 'T'},
> +		{"active-source",	no_argument,		0, 'A'},
> +		{"menu-state",		required_argument,	0, 'M'},
> +
> +		{0, 0, 0, 0}
> +	};
> +
> +	while (1) {
> +		c = getopt_long(argc, argv, "D:edl:cGgs:S:RO:PTAM:ip:", long_options, &option_index);
> +		if (c == -1)
> +			break;
> +		switch (c) {
> +		case 'D':
> +			/* add as first element in todo */
> +			tmp = malloc(sizeof(struct todo));
> +			if (!tmp)
> +				exit(1);
> +			tmp->cmd = c;
> +			tmp->param = strdup(optarg);
> +			tmp->next = list;
> +			list = tmp;
> +			break;
> +		/* cmds with no arg */
> +		case 'A': case 'c': case 'd': case 'e':
> +		case 'g': case 'G': case 'i': case 'P':
> +		case 'R': case 'S': case 'T':
> +		 /* cmds with arg */
> +		case 'l': case 'M': case 'O': case 's':
> +		case 'p':
> +			/* add as last element */
> +			if (!list) {
> +				list = tmp = malloc(sizeof(struct todo));
> +				if (!tmp)
> +					exit(1);
> +			} else {
> +				tmp = list;
> +
> +				while (tmp->next)
> +					tmp = tmp->next;
> +				tmp->next = malloc(sizeof(struct todo));
> +				if (!tmp)
> +					exit(1);
> +				tmp = tmp->next;
> +			}
> +			tmp->cmd = c;
> +			if (optarg)
> +				tmp->param = strdup(optarg);
> +			else
> +				tmp->param = 0;
> +			tmp->next = 0;
> +			break;
> +		case 'h':
> +		default:
> +			while (list) {
> +				tmp = list->next;
> +				free(list->param);
> +				free(list);
> +				list = tmp;
> +			}
> +			return 0;
> +		}
> +	}
> +
> +	return list;
> +}
> +
> +/* Parse a physical address which format is dd.dd.dd.dd
> + * where dd is a integer ranging from 0 to 15 */
> +int parse_paddr(char *s)
> +{
> +	char c;
> +	int r = 0;
> +	int t = 0;
> +	int dots = 0;
> +	if (!s)
> +		return -1;
> +	while ((c = *(s++))) {
> +		if (c == '.') {
> +			r <<= 4;
> +			r |= t;
> +			t = 0;
> +			dots++;
> +		} else if (c >= '0' && c <= '9') {
> +			t = t * 10 + c - '0';
> +		} else {
> +			return -1;
> +		}
> +	}
> +	if (dots != 3)
> +		return -1;
> +	r <<= 4;
> +	r |= t;
> +	return r;
> +}
> +
> +/* Get the first logical address assigned to the used CEC device */
> +int get_addr(struct cec_device *cec)
> +{
> +	uint8_t addrs[CEC_MAX_NUM_LOG_ADDR];
> +	int num_addrs;
> +	int ret;
> +
> +	ret = cec_get_logical_addrs(cec, addrs, &num_addrs);
> +	if (ret != CEC_OK)
> +		return -1;
> +
> +	if (num_addrs)
> +		return addrs[0];
> +	else
> +		return -1;
> +}
> +
> +/* Convert a single character containing a single hexadecimal digit
> + * to an int */
> +int hexdigit(char c)
> +{
> +	if (c >= '0' && c <= '9')
> +		return c - '0';
> +	if (c >= 'a' && c <= 'f')
> +		return 10 + c - 'a';
> +	if (c >= 'A' && c <= 'F')
> +		return 10 + c - 'A';
> +	return -1;
> +}
> +
> +/* Parse string in the format of dd:xxxx
> + * where dd - is an integer denoting the logical address of the recipient device
> + * and xxxx is an array of bytes written in hexadecimal notation.
> + * e.g. 11:1234 means send a message consisting of the following two bytes 0x12
> + * and 0x34 to the device with logical address 11 */
> +int parse_message(struct cec_buffer *msg, char *s)
> +{
> +	int i;
> +	int tmp;
> +
> +	if (*s > '9' || *s < '0')
> +		return 1;
> +	msg->dst = *s - '0';
> +	s++;
> +	if (*s != ':') {
> +		if (*s> '9' || *s < '0')
> +			return 1;
> +		msg->dst *= 10;
> +		msg->dst += *s - '0';
> +		s++;
> +	}
> +
> +	if (*s != ':')
> +		return 1;
> +	s++;
> +
> +	i = 0;
> +	while (*s) {
> +		if (i > CEC_MAX_LENGTH * 2)
> +			return 1;
> +		tmp = hexdigit(*s);
> +		if (tmp == -1)
> +			return 1;
> +		if (i % 2 == 0)
> +			msg->payload[i / 2] = tmp << 4;
> +		else
> +			msg->payload[i / 2] |= tmp;
> +		s++;
> +		i++;
> +	}
> +
> +	msg->len = i / 2;
> +	return 0;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct todo *list;
> +	struct cec_device cec;
> +	uint8_t addr;
> +	int ret;
> +
> +	printf("libgencec test application (c) Samsung 2015\n");
> +
> +	list = parse_args(argc, argv);
> +
> +	if (!list) {
> +		print_usage(argv[0]);
> +		return 1;
> +	}
> +
> +	if (list->cmd == 'D') {
> +		ret = cec_open(&cec, list->param);
> +		list = list->next;
> +	} else {
> +		ret = cec_open(&cec, "/dev/cec0");
> +	}
> +	if (ret != CEC_OK) {
> +		printf("Failed to open CEC device\n");
> +		return 1;
> +	}
> +
> +	printf("Succesfully opened CEC device\n");
> +
> +	/* Main processing loop */
> +	while (list) {
> +		switch (list->cmd) {
> +		case 'd':
> +		case 'e':
> +			ret = cec_enable(&cec, list->cmd == 'e');
> +			if (ret != CEC_OK) {
> +				printf("Failed to %s CEC device\n",
> +					list->cmd == 'e' ? "enable":"disable");
> +				return 1;
> +			}
> +			printf("Successfully %s CEC device\n",
> +					list->cmd == 'e' ? "enabled":"disabled");
> +			break;
> +		case 'l': {
> +			enum cec_device_type type;
> +			if (!strcasecmp(list->param, "tv"))
> +				type = CEC_DEVICE_TYPE_TV;
> +			else if (!strcasecmp(list->param, "record"))
> +				type = CEC_DEVICE_TYPE_RECORD;
> +			else if (!strcasecmp(list->param, "tuner"))
> +				type = CEC_DEVICE_TYPE_TUNER;
> +			else if (!strcasecmp(list->param, "playback"))
> +				type = CEC_DEVICE_TYPE_PLAYBACK;
> +			else if (!strcasecmp(list->param, "audio"))
> +				type = CEC_DEVICE_TYPE_AUDIOSYSTEM;
> +			else if (!strcasecmp(list->param, "switch"))
> +				type = CEC_DEVICE_TYPE_SWITCH;
> +			else if (!strcasecmp(list->param, "videoproc"))
> +				type = CEC_DEVICE_TYPE_VIDEOPROC;
> +			else {
> +				printf("Unrecognised logical address type\n");
> +				return 1;
> +			}
> +
> +			ret = cec_add_logical_addr(&cec, type, &addr);
> +			if (ret != CEC_OK) {
> +				printf("Failed to add a logical address\n");
> +				return 1;
> +			}
> +			printf("Successfully added logical address of type '%s', id=%d\n", list->param, addr);
> +			break;
> +		}
> +		case 'c':
> +			ret = cec_clear_logical_addrs(&cec);
> +			if (ret != CEC_OK) {
> +				printf("Failed to clear logical addresses\n");
> +				return 1;
> +			}
> +			printf("Successfully cleared logical addresses\n");
> +			break;
> +		case 'G': {
> +			uint8_t addrs[CEC_MAX_NUM_LOG_ADDR];
> +			int num_addrs;
> +			int i;
> +
> +			ret = cec_get_logical_addrs(&cec, addrs, &num_addrs);
> +			if (ret != CEC_OK) {
> +				printf("Failed to get logical addresses\n");
> +				return 1;
> +			}
> +			if (num_addrs) {
> +				for (i = 0; i < num_addrs; i++)
> +					printf("Assigned logical address %d\n",
> +					       addrs[i]);
> +			} else {
> +				printf("No logical addresses assigned\n");
> +			}
> +
> +			break;
> +		}
> +		case 'g': {
> +			uint16_t paddr;
> +			ret = cec_get_physical_addr(&cec, &paddr);
> +			if (ret != CEC_OK) {
> +				printf("Failed to get physical address\n");
> +				return 1;
> +			}
> +			printf("Got physical addr: %d.%d.%d.%d\n",
> +				paddr >> 12 & 0xf, paddr >> 8 & 0xf,
> +				paddr >> 4 & 0xf, paddr & 0xf);
> +			break;
> +		}
> +		case 's': {
> +			uint16_t paddr;
> +			paddr = parse_paddr(list->param);
> +			if (paddr == -1) {
> +				printf("Failed to parse physical address (%s)\n", list->param);
> +				return -1;
> +			}
> +			ret = cec_set_physical_addr(&cec, paddr);
> +			if (ret != CEC_OK) {
> +				printf("Failed to set physical address\n");
> +				return 1;
> +			}
> +			printf("Set physical addr: %d.%d.%d.%d\n",
> +				paddr >> 12 & 0xf, paddr >> 8 & 0xf,
> +				paddr >> 4 & 0xf, paddr & 0xf);
> +			break;
> +		}
> +		case 'i': {
> +			struct cec_info info;
> +
> +			ret = cec_get_info(&cec, &info);
> +			if (ret != CEC_OK) {
> +				printf("Failed to get CEC info\n");
> +				return 1;
> +			}
> +
> +			printf(	"Got info: \n"
> +				"version = %d\n"
> +				"vendor_id = 0x%08x\n"
> +				"ports_num = %d\n\n",
> +				info.version,
> +				info.vendor_id,
> +				info.ports_num);
> +
> +			break;
> +		}
> +		case 'p': {
> +			int passthrough;
> +
> +			addr = get_addr(&cec);
> +			if (strcasecmp(list->param, "on") == 0) {
> +				passthrough = 1;
> +			} else if (strcasecmp(list->param, "off") == 0) {
> +				passthrough = 0;
> +			} else {
> +				printf("Unknown state \"%s\"\n", list->param);
> +				return 1;
> +			}
> +
> +			printf("Successfully switched passthrought mode %s\n", list->param);
> +			break;
> +		}
> +		case 'O': {
> +			struct cec_buffer msg;
> +			int addr;
> +
> +			if (strlen(list->param) > CEC_MAX_LENGTH) {
> +				printf("OSD name too long\n");
> +				return -1;
> +			}
> +
> +			addr = get_addr(&cec);
> +			if (addr == -1) {
> +				printf("Failed to get logical address of the CEC device\n");
> +				return 1;
> +			}
> +
> +			msg.src = addr;
> +			msg.dst = 0x0; /* The TV */
> +			msg.len = 1 + strlen(list->param);
> +			msg.payload[0] = 0x47;
> +			memcpy(msg.payload + 1, list->param, strlen(list->param));
> +
> +			ret = cec_send_message(&cec, &msg);
> +			if (ret != CEC_OK) {
> +				printf("Failed to send message\n");
> +				return 1;
> +			}
> +			printf("Successfully sent message - set OSD name to\"%s\"\n", list->param);
> +			break;
> +		}
> +		case 'P': {
> +			struct cec_buffer msg;
> +			int addr;
> +
> +			addr = get_addr(&cec);
> +			if (addr == -1) {
> +				printf("Failed to get logical address of the CEC device\n");
> +				return 1;
> +			}
> +
> +			msg.src = addr;
> +			msg.dst = 0x0; /* The TV */
> +			msg.len = 1;
> +			msg.payload[0] = 0x8f;
> +
> +			ret = cec_send_message(&cec, &msg);
> +			if (ret != CEC_OK) {
> +				printf("Failed to send message\n");
> +				return 1;
> +			}
> +			printf("Successfully sent message - Give Power Status\n");
> +			break;
> +		}
> +		case 'T': {
> +			struct cec_buffer msg;
> +			int addr;
> +
> +			addr = get_addr(&cec);
> +			if (addr == -1) {
> +				printf("Failed to get logical address of the CEC device\n");
> +				return 1;
> +			}
> +
> +			msg.src = addr;
> +			msg.dst = 0x0; /* The TV */
> +			msg.len = 1;
> +			msg.payload[0] = 0x0d;
> +
> +			ret = cec_send_message(&cec, &msg);
> +			if (ret != CEC_OK) {
> +				printf("Failed to send message\n");
> +				return 1;
> +			}
> +			printf("Successfully sent message - Text View On\n");
> +			break;
> +		}
> +		case 'A': {
> +			struct cec_buffer msg;
> +			uint16_t paddr;
> +			int addr;
> +
> +			addr = get_addr(&cec);
> +			if (addr == -1) {
> +				printf("Failed to get logical address of the CEC device\n");
> +				return 1;
> +			}
> +			ret = cec_get_physical_addr(&cec, &paddr);
> +			if (ret != CEC_OK) {
> +				printf("Failed to get physical address\n");
> +				return 1;
> +			}
> +
> +			msg.src = addr;
> +			msg.dst = 0xf; /* The TV */
> +			msg.len = 3;
> +			msg.payload[0] = 0x82;
> +			msg.payload[1] = paddr >> 8;
> +			msg.payload[2] = paddr & 0xff;
> +
> +			ret = cec_send_message(&cec, &msg);
> +			if (ret != CEC_OK) {
> +				printf("Failed to send message\n");
> +				return 1;
> +			}
> +			printf("Successfully sent message - Active Source\n");
> +			break;
> +		}
> +		case 'M': {
> +			struct cec_buffer msg;
> +			int addr;
> +
> +			addr = get_addr(&cec);
> +			if (addr == -1) {
> +				printf("Failed to get logical address of the CEC device\n");
> +				return 1;
> +			}
> +
> +			msg.src = addr;
> +			msg.dst = 0x0; /* The TV */
> +			msg.len = 2;
> +			msg.payload[0] = 0x8e;
> +			if (strcasecmp(list->param, "on") == 0) {
> +				msg.payload[1] = 0;
> +			} else if (strcasecmp(list->param, "off") == 0) {
> +				msg.payload[1] = 1;
> +			} else {
> +				printf("Unknown state \"%s\"\n", list->param);
> +				return 1;
> +			}
> +
> +			ret = cec_send_message(&cec, &msg);
> +			if (ret != CEC_OK) {
> +				printf("Failed to send message\n");
> +				return 1;
> +			}
> +			printf("Successfully sent message - Menu Status\n");
> +			break;
> +		}
> +		case 'S': {
> +			struct cec_buffer msg;
> +			int addr;
> +			int ret;
> +			int i;
> +
> +			ret = parse_message(&msg, list->param);
> +			if (ret) {
> +				printf("Failed to parse message to send\n");
> +				return 1;
> +			}
> +			printf("Sending message=0x");
> +			for (i = 0; i < msg.len; i++)
> +				printf("%02x", msg.payload[i]);
> +			printf(" (length=%d) to addr=%d\n", msg.len, msg.dst);
> +			addr = get_addr(&cec);
> +			if (addr == -1) {
> +				printf("Failed to get logical address of the CEC device\n");
> +				return 1;
> +			}
> +			msg.src = addr;
> +
> +			ret = cec_send_message(&cec, &msg);
> +			if (ret != CEC_OK) {
> +				printf("Failed to send message\n");
> +				return 1;
> +			}
> +			printf("Successfully sent custom message\n");
> +			break;
> +		}
> +		case 'R': {
> +			struct cec_buffer msg;
> +			int i;
> +
> +			ret = cec_receive_message(&cec, &msg);
> +			if (ret == CEC_TIMEOUT) {
> +				printf("CEC receive message timed out\n");
> +				return 2;
> +			} else if (ret != CEC_OK) {
> +				printf("Failed to receive a message\n");
> +				return 1;
> +			}
> +
> +			printf("Received message of length %d\n", msg.len);
> +			for (i = 0; i < msg.len; i++)
> +				printf("%02x", msg.payload[i]);
> +			printf("\n");
> +			break;
> +		}
> +		default:
> +			printf("Command '%c' not yet implemented.\n", list->cmd);
> +			break;
> +		}
> +
> +		list = list->next;
> +	}
> +
> +	return 0;
> +}
> diff --git a/include/gencec.h b/include/gencec.h
> new file mode 100644
> index 0000000..b727ddc
> --- /dev/null
> +++ b/include/gencec.h
> @@ -0,0 +1,255 @@
> +/*
> + * Copyright 2015 Samsung Electronics Co. Ltd
> + *
> + * Licensed under the Apache License, Version 2.0 (the "License");
> + * you may not use this file except in compliance with the License.
> + * You may obtain a copy of the License at
> + *
> + *      http://www.apache.org/licenses/LICENSE-2.0
> + *
> + * Unless required by applicable law or agreed to in writing, software
> + * distributed under the License is distributed on an "AS IS" BASIS,
> + * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> + * See the License for the specific language governing permissions and
> + * limitations under the License.
> + */
> +
> +#ifndef __GENCEC_H__
> +
> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <time.h>
> +
> +/* Maximum length of the CEC message */
> +#define CEC_MAX_LENGTH		15 /* 16 including the automatically added
> +				    * address byte. */
> +#define MAX_NUM_OF_HDMI_PORTS	16
> +#define CEC_MAX_NUM_LOG_ADDR	4
> +#define DEFAULT_TIMEOUT		1000
> +
> +/*  cec_version: list of CEC versions */
> +enum cec_version {
> +	CEC_VER_UNKNOWN,
> +	CEC_VER_1_0,
> +	CEC_VER_1_1,
> +	CEC_VER_1_2,
> +	CEC_VER_1_3,
> +	CEC_VER_1_3A,
> +	CEC_VER_1_3B,
> +	CEC_VER_1_3C,
> +	CEC_VER_1_4,
> +	CEC_VER_1_4B,
> +	CEC_VER_2_0,
> +};

Isn't this a duplicate of what's in uapi/linux/cec.h?

> +
> +enum cec_device_type {
> +	/* Used internally for error handling */
> +	CEC_DEVICE_TYPE_EMPTY,
> +	CEC_DEVICE_TYPE_TV,
> +	CEC_DEVICE_TYPE_RECORD,
> +	CEC_DEVICE_TYPE_TUNER,
> +	CEC_DEVICE_TYPE_PLAYBACK,
> +	CEC_DEVICE_TYPE_AUDIOSYSTEM,
> +	CEC_DEVICE_TYPE_SWITCH,
> +	CEC_DEVICE_TYPE_VIDEOPROC,
> +};

Same here.

> +
> +/**
> + * struct cec_device - a structure used to keep context of the current used CEC
> + *		       device
> + * @caps:	used to keep a pointer to the kernel caps structure for the
> + *		device
> + * @handle:	this is used to keep the file handle to the CEC device
> + * @initialised: flag set if the structure was properly initialised
> + * @log_addr:	an array containing the assigned logical addresses
> + * @log_addr_type_int: an array containing the logical addresses' types as
> + *		       needed by the kernel
> + * @dev_type:	device type, as neede by the library
> + * @dev_type_int: primary device type, as needed by the kernel driver
> + * @num_log_addr: number of ssigned logical addresses
> + */
> +struct cec_device {
> +	void *caps;
> +	int handle;
> +	int initialised;
> +	uint32_t log_addr[CEC_MAX_NUM_LOG_ADDR];
> +	uint32_t log_addr_type_int[CEC_MAX_NUM_LOG_ADDR];
> +	enum cec_device_type dev_type[CEC_MAX_NUM_LOG_ADDR];
> +	uint32_t dev_type_int[CEC_MAX_NUM_LOG_ADDR];
> +	int num_log_addr;
> +};
> +
> +/* cec_error: list of CEC framework errors */
> +enum cec_error {
> +	CEC_OK /* Success */,
> +	CEC_TIMEOUT /* Timeout occured */,
> +	CEC_NO_ADDR_LEFT /* No more logical addresses left */,
> +	CEC_ERROR,
> +};
> +
> +/**
> + * struct hdmi_port_info - Information about a HDMI port
> + * @port_number: the port number
> + */
> +struct hdmi_port_info {
> +	uint8_t port_number;
> +};
> +
> +/**
> + * struct cec_info - a structure used to get information about the CEC device
> + * @version:	supported CEC version
> + * @vendor_id:	the vendor ID
> + * @ports_num:	number of HDMI ports available in the system
> + * @ports_info:	an array containing information about HDMI ports
> + * */
> +struct cec_info {
> +	enum cec_version version;
> +	uint32_t vendor_id;
> +	unsigned int ports_num;
> +	struct hdmi_port_info ports_info[MAX_NUM_OF_HDMI_PORTS];
> +};
> +
> +/**
> + * struct cec_msg - a structure used to store message that were received or are
> + *		    to be sent
> + * @dst:	The address of the destination device
> + * @src:	The address of the source device
> + * @len:	The length of the payload of the message
> + * @payload:	The payload of the message
> + * @ts:		The timestamp for received messages
> + */
> +struct cec_buffer {
> +	uint8_t dst;
> +	uint8_t src;
> +	uint8_t len;
> +	uint8_t payload[CEC_MAX_LENGTH];
> +	struct timespec ts;
> +};
> +
> +/**
> + * cec_open() - Open a CEC device
> + * @dev:	pointer to a structure that will hold the state of the device
> + * @path:	path to the CEC device
> + * Returns:	on success CEC_OK, on error returns an negative error code
> + */
> +int cec_open(struct cec_device *dev, char *path);

Can you add a newline after each function? It makes is a bit more readable

> +/**
> + * cec_close() - Close a CEC device
> + * @dev:	pointer to a structure that holds the state of the device
> + * Returns:	on success CEC_OK, on error returns an negative error code
> + */
> +int cec_close(struct cec_device *dev);
> +/**
> + * cec_is_enabled() - Check whether the CEC device is enabled
> + * @dev:	pointer to a structure that holds the state of the device
> + * Returns:	true if all is ok and the CEC device is enabled, false otherwise
> + */
> +bool cec_is_enabled(struct cec_device *dev);
> +/**
> + * cec_enable() - Enable a CEC device
> + * @dev:	pointer to a structure that will hold the state of the device
> + * @enable:	true to enable the CEC device, false to disable the CEC device
> + * Returns:	on success CEC_OK, on error returns an negative error code
> + */
> +int cec_enable(struct cec_device *dev, bool enable);
> +/**
> + * cec_passthrough() - Enable a CEC device
> + * @dev:	pointer to a structure that will hold the state of the device
> + * @enable:	true to enable the passthrough mode, false to disable
> + * Returns:	on success CEC_OK, on error returns an negative error code
> + */
> +int cec_passthrough(struct cec_device *dev, bool enable);
> +/**
> + * cec_info() - Returns information about the CEC device
> + * @dev:	pointer to a structure that holds the state of the device
> + * @info:	pointer to a info structure that will hold the information about
> + *		the CEC device
> + * Returns:	on success CEC_OK, on error returns an negative error code
> + */
> +int cec_get_info(struct cec_device *dev, struct cec_info *info);
> +/**
> + * cec_is_connected() - Return information about whether a device is connected
> + *			to the port
> + * @dev:	pointer to a structure that holds the state of the device
> + * Returns:	when a device is connected to the port returns CEC_CONNECTED,
> + *		CEC_DISCONNECTED when there is no device connected, on error
> + *		returns an negative error code
> + */
> +int cec_is_connected(struct cec_device *dev);
> +/**
> + * cec_send_message() - Send a message over the CEC bus
> + * @dev:	pointer to a structure that holds the state of the device
> + * @msg:	the message do be sent over the CEC bus
> + * Returns:	CEC_OK on success
> + *		CEC_REPLY on successful send and reply receive
> + *		CEC_REPLY_TIMEOUT when waiting for reply timed out
> + *		CEC_TIMEOUT when a timeout occurred while sending the message
> + *		negative error code on other error
> + */
> +int cec_send_message(struct cec_device *dev, struct cec_buffer *msg);
> +/**
> + * cec_receive_message() - Receive a message over the CEC bus
> + * @dev:	pointer to a structure that holds the state of the device
> + * @msg:	a structure used to store the message received over the CEC bus
> + * Returns:	CEC_OK on success
> + *		CEC_TIMEOUT when a timeout occurred while waiting for message
> + *		negative error code on error
> + * Remarks:	when waiting for a reply, the reply is stored in the msg struct
> + */
> +int cec_receive_message(struct cec_device *dev, struct cec_buffer *msg);
> +/**
> + * cec_get_logical_addrs() - Add a new logical address to the CEC device
> + * @dev:	pointer to a structure that holds the state of the device
> + * @addr:	pointer to an array to hold the list of assigned logical
> + *		addresses, the size should be CEC_MAX_NUM_LOG_ADDR
> + * @num_addr:	pointer to an int that will hold the number of assigned
> + *		logical addresses
> + * Returns:	CEC_OK on success
> + *		negative error code on error
> + */
> +int cec_get_logical_addrs(struct cec_device *dev, uint8_t *addr, int *num_addr);
> +/**
> + * cec_add_logical_addr() - Add a new logical address to the CEC device
> + * @dev:	pointer to a structure that holds the state of the device
> + * @type:	the type of the device that is to be added, please note that
> + *		this indicated the type and not the address that will be
> + *		assigned
> + * @addr:	a pointer to a location where to store the assigned logical
> + *		address
> + * Returns:	CEC_OK on success
> + *		CEC_TIMEOUT when a timeout occurred while waiting for message
> + *		CEC_NO_ADDR_LEFT when all addresses related to the chosen device
> + *		type are already taken
> + *		negative error code on error
> + */
> +int cec_add_logical_addr(struct cec_device *dev, enum cec_device_type type,
> +			 uint8_t *addr);
> +/**
> + * cec_clear_logical_addrs() - Clear the logical addresses that were assigned to
> + * the device
> + * @dev:	pointer to a structure that holds the state of the device
> + * Returns:	CEC_OK on success
> + *		CEC_TIMEOUT when a timeout occurred while waiting for message
> + *		negative error code on error
> + */
> +int cec_clear_logical_addrs(struct cec_device *dev);
> +/**
> + * cec_get_physical_addr() - Get the physical addr of the CEC device
> + * @dev:	pointer to a structure that holds the state of the device
> + * @phys_addr:	pointer to a uint16_t which will hold the physical address
> + * Returns:	CEC_OK on success
> + *		CEC_TIMEOUT when a timeout occurred while waiting for message
> + *		negative error code on error
> + */
> +int cec_get_physical_addr(struct cec_device *dev, uint16_t *phys_addr);
> +/**
> + * cec_set_physical_addr() - Get the physical addr of the CEC device
> + * @dev:	pointer to a structure that holds the state of the device
> + * @phys_addr:	a uint16_t which holding the physical address
> + * Returns:	CEC_OK on success
> + *		CEC_TIMEOUT when a timeout occurred while waiting for message
> + *		negative error code on error
> + */
> +int cec_set_physical_addr(struct cec_device *dev, uint16_t phys_addr);
> +
> +#endif /* __GENCEC_H__ */

Why is it called 'gencec'? The 'cec' part is obvious, but where does 'gen'
stand for?

> diff --git a/src/gencec.c b/src/gencec.c
> new file mode 100644
> index 0000000..2224115
> --- /dev/null
> +++ b/src/gencec.c
> @@ -0,0 +1,445 @@
> +/*
> + * Copyright 2015 Samsung Electronics Co. Ltd
> + *
> + * Licensed under the Apache License, Version 2.0 (the "License");
> + * you may not use this file except in compliance with the License.
> + * You may obtain a copy of the License at
> + *
> + *      http://www.apache.org/licenses/LICENSE-2.0
> + *
> + * Unless required by applicable law or agreed to in writing, software
> + * distributed under the License is distributed on an "AS IS" BASIS,
> + * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> + * See the License for the specific language governing permissions and
> + * limitations under the License.
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdbool.h>
> +#include <stdint.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <linux/cec.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include "gencec.h"
> +
> +bool cec_is_enabled(struct cec_device *dev)
> +{
> +	struct cec_caps *caps = (struct cec_caps *)dev->caps;
> +	int ret;
> +
> +	if (!dev)
> +		return CEC_ERROR;
> +	if (!dev->initialised)
> +		return CEC_ERROR;
> +
> +	if (caps->capabilities && CEC_CAP_STATE) {

In all the capabilities checks you use && instead of &. It's a bitmask, so
you should use &.

> +		uint32_t arg;
> +
> +		ret = ioctl(dev->handle, CEC_G_ADAP_STATE, &arg);
> +		if (ret)
> +			return CEC_ERROR;

Weird mix between bool and CEC_ERROR.

In general I am not keen on introducing your own 'OK/ERROR' defines when
you have bools.

> +		if (arg == 0)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +int cec_enable(struct cec_device *dev, bool enable)
> +{
> +	struct cec_caps *caps = (struct cec_caps *)dev->caps;
> +	int ret;
> +
> +	if (!dev)
> +		return CEC_ERROR;
> +	if (!dev->initialised)
> +		return CEC_ERROR;
> +
> +	if (caps->capabilities && CEC_CAP_STATE) {
> +		uint32_t arg;
> +
> +		arg = enable ? CEC_STATE_ENABLED : CEC_STATE_DISABLED;
> +		ret = ioctl(dev->handle, CEC_S_ADAP_STATE, &arg);
> +		if (ret)
> +			return CEC_ERROR;
> +	}
> +
> +	return CEC_OK;
> +}
> +
> +int cec_passthrough(struct cec_device *dev, bool enable)
> +{
> +	struct cec_caps *caps = (struct cec_caps *)dev->caps;
> +	int ret;
> +
> +	if (!dev)
> +		return CEC_ERROR;
> +	if (!dev->initialised)
> +		return CEC_ERROR;
> +
> +	if (caps->capabilities && CEC_CAP_PASSTHROUGH) {
> +		uint32_t arg;
> +
> +		arg = enable ? CEC_PASSTHROUGH_ENABLED : CEC_PASSTHROUGH_DISABLED;
> +		ret = ioctl(dev->handle, CEC_S_PASSTHROUGH, &arg);
> +		if (ret)
> +			return CEC_ERROR;
> +	}
> +
> +	return CEC_OK;
> +}
> +
> +static int check_state(struct cec_device *dev)
> +{
> +	if (!dev)
> +		return CEC_ERROR;
> +	if (!dev->initialised)
> +		return CEC_ERROR;
> +	if (!cec_is_enabled(dev))
> +		return CEC_ERROR;
> +	return CEC_OK;
> +}
> +
> +int cec_open(struct cec_device *dev, char *path)
> +{
> +	int ret;
> +
> +	if (!dev || !path)
> +		return CEC_ERROR;
> +
> +	memset(dev, 0, sizeof(*dev));
> +
> +	dev->handle = open(path, O_RDWR);
> +	if (dev->handle == -1)
> +		return CEC_ERROR;
> +
> +	dev->caps = malloc(sizeof(struct cec_caps));
> +	if (!dev->caps) {
> +		close(dev->handle);
> +		return CEC_ERROR;
> +	}
> +
> +	ret = ioctl(dev->handle, CEC_G_CAPS, dev->caps);
> +	if (ret) {
> +		free(dev->caps);
> +		close(dev->handle);
> +		return CEC_ERROR;
> +	}
> +
> +	dev->initialised = 1;
> +
> +	return CEC_OK;
> +}
> +
> +int cec_close(struct cec_device *dev)
> +{
> +	if (!dev)
> +		return CEC_ERROR;
> +	if (close(dev->handle) == -1)
> +		return CEC_ERROR;
> +	dev->initialised = 0;
> +	return CEC_OK;
> +}
> +
> +int cec_get_info(struct cec_device *dev, struct cec_info *info)
> +{
> +	struct cec_caps *caps;
> +	int i;
> +
> +	if (check_state(dev) != CEC_OK || !info)
> +		return CEC_ERROR;
> +
> +	caps = (struct cec_caps *)(dev->caps);
> +
> +	info->vendor_id = caps->vendor_id;
> +	switch (caps->version) {
> +	case CEC_VERSION_1_4:
> +		info->version = CEC_VER_1_4;
> +		break;
> +	case CEC_VERSION_2_0:
> +		info->version = CEC_VER_2_0;
> +		break;
> +	default:
> +		info->version = CEC_VER_UNKNOWN;
> +		break;
> +	}
> +	info->ports_num = 1; /* ? */
> +
> +	for (i = 0; i < MAX_NUM_OF_HDMI_PORTS; i++) {
> +		info->ports_info[i].port_number =  i;

I'm not sure what the ports idea is about...

> +	}
> +
> +	return CEC_OK;
> +}
> +
> +int cec_is_connected(struct cec_device *dev)
> +{
> +	if (!dev)
> +		return CEC_ERROR;
> +	/* TODO */
> +	return CEC_OK;
> +}
> +
> +int cec_send_message(struct cec_device *dev, struct cec_buffer *msg)
> +{
> +	struct cec_msg msg_int;
> +	int i, ret;
> +
> +	if (check_state(dev) != CEC_OK || !msg)
> +		return CEC_ERROR;
> +
> +	if (msg->len > CEC_MAX_LENGTH)
> +		return CEC_ERROR;
> +
> +	msg_int.len = msg->len + 1;
> +	msg_int.msg[0] =  msg->src << 4 & 0xf0;
> +	msg_int.msg[0] |= msg->dst & 0x0f;
> +	for (i = 0; i < msg->len; i++)
> +		msg_int.msg[i + 1] = msg->payload[i];
> +	msg_int.reply = 0;
> +	msg_int.timeout = DEFAULT_TIMEOUT;
> +
> +	ret = ioctl(dev->handle, CEC_TRANSMIT, &msg_int);
> +	if (ret) {
> +		if (errno == ETIMEDOUT)
> +			return CEC_TIMEOUT;
> +		return CEC_ERROR;
> +	}
> +
> +
> +	return CEC_OK;
> +}

Why not return the errno value instead of inventing new error codes?

> +
> +int cec_receive_message(struct cec_device *dev, struct cec_buffer *msg)
> +{
> +	struct cec_msg msg_int;
> +	int i, ret;
> +
> +	if (check_state(dev) != CEC_OK || !msg)
> +		return CEC_ERROR;
> +
> +	msg_int.timeout = DEFAULT_TIMEOUT;
> +	ret = ioctl(dev->handle, CEC_RECEIVE, &msg_int);
> +	if (ret) {
> +		if (errno == ETIMEDOUT)
> +			return CEC_TIMEOUT;
> +		return CEC_ERROR;
> +	}
> +	if (msg_int.len == 0 || msg_int.len > CEC_MAX_LENGTH + 1)
> +		return CEC_ERROR;
> +
> +	msg->src = msg_int.msg[0] >> 4 & 0xf;
> +	msg->dst = msg_int.msg[0]  & 0xf;
> +	msg->ts.tv_sec = msg_int.ts / 1000000000;
> +	msg->ts.tv_nsec = msg_int.ts % 1000000000;
> +	msg->len = msg_int.len - 1;
> +	for (i = 0; i < msg->len; i++)
> +		msg->payload[i] = msg_int.msg[i + 1];
> +
> +	return CEC_OK;
> +}
> +
> +static int dev_type_to_int_dev_type(enum cec_device_type type)
> +{
> +	switch (type) {
> +	case CEC_DEVICE_TYPE_TV:
> +		return CEC_PRIM_DEVTYPE_TV;
> +	case CEC_DEVICE_TYPE_RECORD:
> +		return CEC_PRIM_DEVTYPE_RECORD;
> +	case CEC_DEVICE_TYPE_TUNER:
> +		return CEC_PRIM_DEVTYPE_TUNER;
> +	case CEC_DEVICE_TYPE_PLAYBACK:
> +		return CEC_PRIM_DEVTYPE_PLAYBACK;
> +	case CEC_DEVICE_TYPE_AUDIOSYSTEM:
> +		return CEC_PRIM_DEVTYPE_AUDIOSYSTEM;
> +	case CEC_DEVICE_TYPE_SWITCH:
> +		return CEC_PRIM_DEVTYPE_SWITCH;
> +	case CEC_DEVICE_TYPE_VIDEOPROC:
> +		return CEC_PRIM_DEVTYPE_VIDEOPROC;
> +	}
> +	return -1;
> +}
> +
> +static int dev_type_to_int_addr_type(enum cec_device_type type)
> +{
> +	switch (type) {
> +	case CEC_DEVICE_TYPE_TV:
> +		return CEC_LOG_ADDR_TYPE_TV;
> +	case CEC_DEVICE_TYPE_RECORD:
> +		return CEC_LOG_ADDR_TYPE_RECORD;
> +	case CEC_DEVICE_TYPE_TUNER:
> +		return CEC_LOG_ADDR_TYPE_TUNER;
> +	case CEC_DEVICE_TYPE_PLAYBACK:
> +		return CEC_LOG_ADDR_TYPE_PLAYBACK;
> +	case CEC_DEVICE_TYPE_AUDIOSYSTEM:
> +		return CEC_LOG_ADDR_TYPE_AUDIOSYSTEM;
> +	case CEC_DEVICE_TYPE_SWITCH:
> +		return CEC_LOG_ADDR_TYPE_UNREGISTERED;
> +	case CEC_DEVICE_TYPE_VIDEOPROC:
> +		return CEC_LOG_ADDR_TYPE_SPECIFIC;
> +	case CEC_DEVICE_TYPE_EMPTY:
> +	default:
> +		return -1;
> +	}
> +}
> +
> +#if (CEC_MAX_LOG_ADDRS < CEC_MAX_NUM_LOG_ADDR)
> +#error	The CEC_MAX_NUM_LOG_ADDR (lib define) is more than CEC_MAX_LOG_ADDRS \
> +	(kernel framework defined)
> +#endif
> +
> +static int _cec_get_logical_addrs(struct cec_device *dev)
> +{
> +	struct cec_log_addrs log_addr;
> +	uint32_t dev_type;
> +	uint32_t addr_type;
> +	int ret;
> +	int i;
> +
> +	if (check_state(dev) != CEC_OK)
> +		return CEC_ERROR;
> +
> +	memset(&log_addr, 0, sizeof(log_addr));
> +	ret = ioctl(dev->handle, CEC_G_ADAP_LOG_ADDRS, &log_addr);
> +	if (ret)
> +		return CEC_ERROR;
> +
> +	for (i = 0; i < log_addr.num_log_addrs; i++) {
> +		dev->dev_type_int[i] = log_addr.primary_device_type[i];
> +		dev->log_addr_type_int[i] = log_addr.log_addr_type[i];
> +		dev->log_addr[i] = log_addr.log_addr[i];
> +	}
> +
> +	dev->num_log_addr = log_addr.num_log_addrs;
> +
> +	return CEC_OK;
> +}
> +
> +int cec_get_logical_addrs(struct cec_device *dev, uint8_t *addr, int *num_addr)
> +{
> +	int i;
> +
> +	if (!addr || !num_addr)
> +		return CEC_ERROR;
> +
> +	if (_cec_get_logical_addrs(dev) != CEC_OK)
> +		return CEC_ERROR;
> +
> +	*num_addr = dev->num_log_addr;
> +	for (i = 0; i < *num_addr; i++)
> +		addr[i] = dev->log_addr[i];
> +
> +	return CEC_OK;
> +}
> +
> +int cec_add_logical_addr(struct cec_device *dev, enum cec_device_type type,
> +			 uint8_t *addr)
> +{
> +	struct cec_log_addrs log_addr;
> +	uint32_t dev_type;
> +	uint32_t addr_type;
> +	int ret;
> +	int i;
> +
> +	if (check_state(dev) != CEC_OK)
> +		return CEC_ERROR;
> +
> +	/* Refresh copy of logical addrs */
> +	if (_cec_get_logical_addrs(dev) != CEC_OK)
> +		return CEC_ERROR;
> +
> +	if (dev->num_log_addr  >= CEC_MAX_NUM_LOG_ADDR)
> +		return CEC_NO_ADDR_LEFT;
> +
> +	memset(&log_addr, 0, sizeof(log_addr));
> +
> +	if (type != CEC_DEVICE_TYPE_EMPTY) {
> +		dev->dev_type[dev->num_log_addr] = type;
> +		dev->dev_type_int[dev->num_log_addr] = dev_type_to_int_dev_type(type);
> +		dev->log_addr_type_int[dev->num_log_addr] = dev_type_to_int_addr_type(type);
> +		if (dev->dev_type_int[dev->num_log_addr] == -1 ||
> +			dev->log_addr_type_int[dev->num_log_addr] == -1)
> +			return CEC_ERROR;
> +		dev->num_log_addr++;
> +		if (dev->num_log_addr  >= CEC_MAX_NUM_LOG_ADDR) {
> +			dev->num_log_addr--;
> +			return CEC_NO_ADDR_LEFT;
> +		}
> +	}
> +
> +	log_addr.cec_version = CEC_VERSION_1_4;
> +	log_addr.num_log_addrs = dev->num_log_addr;
> +	for (i = 0; i < dev->num_log_addr; i++) {
> +		log_addr.primary_device_type[i] = dev->dev_type_int[i];
> +		log_addr.log_addr_type[i] = dev->log_addr_type_int[i];
> +	}
> +	ret = ioctl(dev->handle, CEC_S_ADAP_LOG_ADDRS, &log_addr);
> +	if (ret) {
> +		/* Should it call set log addr again without the last added address? */
> +		if (--dev->num_log_addr > 0)
> +			cec_add_logical_addr(dev, CEC_DEVICE_TYPE_EMPTY, 0);
> +		return CEC_ERROR;
> +	}
> +
> +	dev->log_addr[i - 1] = log_addr.log_addr[i - 1];
> +	if (addr)
> +		*addr = log_addr.log_addr[i - 1];
> +
> +	return CEC_OK;
> +}
> +
> +int cec_clear_logical_addrs(struct cec_device *dev)
> +{
> +	struct cec_log_addrs log_addr;
> +	uint32_t dev_type;
> +	uint32_t addr_type;
> +	int ret;
> +	int i;
> +
> +	if (check_state(dev) != CEC_OK)
> +		return CEC_ERROR;
> +
> +	memset(&log_addr, 0, sizeof(log_addr));
> +	log_addr.num_log_addrs = 0;
> +	log_addr.cec_version = CEC_VERSION_1_4;
> +
> +	ret = ioctl(dev->handle, CEC_S_ADAP_LOG_ADDRS, &log_addr);
> +	if (ret)
> +		return CEC_ERROR;
> +
> +	return CEC_OK;
> +}
> +
> +int cec_get_physical_addr(struct cec_device *dev, uint16_t *phys_addr)
> +{
> +	int ret;
> +
> +	if (check_state(dev) != CEC_OK || !phys_addr)
> +		return CEC_ERROR;
> +	ret = ioctl(dev->handle, CEC_G_ADAP_PHYS_ADDR, phys_addr);
> +	if (ret)
> +		return CEC_ERROR;
> +
> +	return CEC_OK;
> +}
> +
> +int cec_set_physical_addr(struct cec_device *dev, uint16_t phys_addr)
> +{
> +	int ret;
> +
> +	if (check_state(dev) != CEC_OK)
> +		return CEC_ERROR;
> +	ret = ioctl(dev->handle, CEC_S_ADAP_PHYS_ADDR, &phys_addr);
> +	if (ret)
> +		return CEC_ERROR;
> +
> +	return CEC_OK;
> +}
> +
> 

Regards,

	Hans
