Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailr.qinetiq-tim.net ([128.98.1.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <s.kilvington@eris.qinetiq.com>) id 1K66Pf-0006qg-Gx
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 18:09:36 +0200
Received: from mailhost.eris.qinetiq.com (mail-relay.eris.qinetiq.com
	[128.98.2.2])
	by mailr.qinetiq-tim.net (Postfix) with SMTP id C729C8CCA6
	for <linux-dvb@linuxtv.org>; Tue, 10 Jun 2008 17:09:00 +0100 (BST)
Message-ID: <484EA718.20807@eris.qinetiq.com>
Date: Tue, 10 Jun 2008 17:08:56 +0100
From: Simon Kilvington <s.kilvington@eris.qinetiq.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <48480A2D.9010507@eris.qinetiq.com> <48480C33.3060705@onelan.co.uk>
In-Reply-To: <48480C33.3060705@onelan.co.uk>
Content-Type: multipart/mixed; boundary="------------090502090906040705090806"
Subject: Re: [linux-dvb] UK FreeView logical channel numbers
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------090502090906040705090806
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Simon Farnsworth wrote:
> Simon Kilvington wrote:
>> Hi,
>>
>>     does anyone know where the logical channel numbers are
>> transmitted in FreeView? - ie BBC1 is 1, BBC News is 80, etc - I've been
>> looking at the PAT and PMTs with dvbsnoop but can't see anything
>> obvious.
>>
> 
> It's in the NIT, using a private descriptor - scan from dvb-apps
> (http://linuxtv.org/hg/dvb-apps/file/9311c900f746/util/scan/scan.c)
> knows about them, and they're fully specced in the DTG 'D-Book' (see
> http://dtg.org.uk/publications/books.html).

thanks for the info

the reason I wanted to know was because when I did a scan with mythtv I
had to give it each frequency by hand, then it only managed to find the
channel numbers for the channels on one mux - though this may be because
the nit on my transmitter seems to be split into two bits - one nit has
the info for 5 muxs, the other nit has the info for the other mux

anyway, I wrote a small program that will get the channel numbers out
of the nit(s) and dump some sql statements that you can use to update
the channel numbers in an existing mythtv database - I've attached it
here, compile it like this:

gcc -o get-lcns get-lcns.c

and run it like this (you'll probably need different dvbtune params):

dvbtune -f 722166667 -qam 16 -cr 3_4 && ./get-lcns > lcns

it will print a load of sql commands to stdout, so the > will put them
in the "lcns" file. You can just pipe the output into mysql, like this:

cat lcns | mysql -umythtv -pmythtv mythconverg

to update your channel table

- --
Simon Kilvington


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFITqcYmt9ZifioJSwRAiFvAJsF3JkuO7XbPw9/FVyCLSU76cYDTwCfV1sx
kr74Bd1GCOJRxltIedK11aY=
=kfY/
-----END PGP SIGNATURE-----

--------------090502090906040705090806
Content-Type: text/x-csrc;
 name="get-lcns.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="get-lcns.c"

/*
 * dvbtune -f 722166667 -qam 16 -cr 3_4 && dvbsnoop 0x10
 *
 * NIT:
 * PID=0x10
 * TID=0x40
 * tag=0x83
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/select.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <linux/dvb/dmx.h>

#define TIMEOUT		30

#define MAX_TABLE_LEN	4096

/* Network Information Table PID and TID */
#define PID_NIT		0x0010
#define TID_NIT		0x40

#define TAG_LCN		0x83

bool read_nit(char *, unsigned int, unsigned char *);
bool read_table(char *, uint16_t, uint8_t, unsigned int, unsigned char *);
void fatal(char *, ...);

int main(void)
{
	unsigned char nit[MAX_TABLE_LEN];
	unsigned char *data;
	unsigned int section_len;
	unsigned int nit_len;
	unsigned int descriptors_loop_len;
	unsigned int transport_stream_id;
	unsigned int ntransport_ids;
	unsigned int transport_ids[6];
	unsigned int i;

	/*
	 * Malvern transmitter (repeater for Sutton Coldfield) broadcasts 2 NITs
	 * one has the LCNs for 5 MUXs
	 * the other has the LCNs for the other MUX
	 */
	ntransport_ids = 0;
	while(ntransport_ids < 6)
	{
		bzero(nit, MAX_TABLE_LEN);
		if(!read_nit("/dev/dvb/adapter0/demux0", TIMEOUT, nit))
			fatal("Unable to read NIT");

		/* generic header */
		data = nit;
		section_len = ((data[1] & 0x0f) << 8) | data[2];
		data += 8;
		/* header + CRC */
		nit_len = section_len - (5 + 4);

		/* skip the first descriptors loop */
		descriptors_loop_len = ((data[0] & 0x0f) << 8) | data[1];
		data += descriptors_loop_len + 4;
		nit_len -= descriptors_loop_len + 4;

		while(nit_len > 6)
		{
			transport_stream_id = (data[0] << 8) | data[1];
			/* have we already seen it */
			for(i=0; i<ntransport_ids; i++)
				if(transport_stream_id == transport_ids[i])
					continue;
			transport_ids[ntransport_ids++] = transport_stream_id;
			fprintf(stderr, "transport_stream_id=0x%x\n", transport_stream_id);
			descriptors_loop_len = ((data[4] & 0x0f) << 8) | data[5];
			data += 6;
			nit_len -= descriptors_loop_len + 6;
			while(descriptors_loop_len > 0)
			{
				unsigned char desc_tag = data[0];
				unsigned char desc_len = data[1] + 2;
				data += 2;
				if(desc_tag == TAG_LCN)
				{
					for(i=0; i<desc_len; i+=4)
					{
						unsigned int sid, lcn;
						sid = (data[i] << 8) | data[i+1];
						lcn = ((data[i+2] & 0x03) << 8) | data[i+3];
						printf("UPDATE channel SET chanid=\"%u\", channum=\"%u\" WHERE serviceid=\"%u\";\n", lcn + 1000, lcn, sid);
					}
				}
				data += desc_len - 2;
				descriptors_loop_len -= desc_len;
			}
		}

	}

	return 0;
}

/*
 * output buffer must be at least MAX_TABLE_LEN bytes
 * returns false if it timesout
 */

bool
read_nit(char *demux, unsigned int timeout, unsigned char *out)
{
	/* read it from the DVB card */
	if(!read_table(demux, PID_NIT, TID_NIT, timeout, out))
	{
		fatal("Unable to read NIT");
		return false;
	}

	return true;
}

/*
 * output buffer must be at least MAX_TABLE_LEN bytes
 * returns false if it timesout
 */

bool
read_table(char *device, uint16_t pid, uint8_t tid, unsigned int secs, unsigned char *out)
{
	int fd_data;
	struct dmx_sct_filter_params sctFilterParams;
	fd_set readfds;
	struct timeval timeout;
	int n;

	if((fd_data = open(device, O_RDWR)) < 0)
	{
		fatal("open '%s': %s", device, strerror(errno));
		return false;
	}

	memset(&sctFilterParams, 0, sizeof(sctFilterParams));
	sctFilterParams.pid = pid;
	sctFilterParams.timeout = 0;
	sctFilterParams.flags = DMX_IMMEDIATE_START;
       	sctFilterParams.filter.filter[0] = tid;
 	sctFilterParams.filter.mask[0] = 0xff;

	if(ioctl(fd_data, DMX_SET_FILTER, &sctFilterParams) < 0)
	{
		fatal("ioctl DMX_SET_FILTER: %s", strerror(errno));
		close(fd_data);
		return false;
	}

	timeout.tv_sec = secs;
	timeout.tv_usec = 0;
	do
	{
		/* we check for out[0]==tid to see if we read the table */
		out[0] = ~tid;
		FD_ZERO(&readfds);
		FD_SET(fd_data, &readfds);
		if(select(fd_data + 1, &readfds, NULL, NULL, &timeout) < 0)
		{
			if(errno == EINTR)
				continue;
			fatal("read_table: select: %s", strerror(errno));
			close(fd_data);
			return false;
		}
		if(FD_ISSET(fd_data, &readfds))
		{
			if((n = read(fd_data, out, MAX_TABLE_LEN)) < 0)
			{
				fatal("read: %s", strerror(errno));
				close(fd_data);
				return false;
			}
		}
		else
		{
			fatal("Timeout reading %s", device);
			close(fd_data);
			return false;
		}
	}
	while(out[0] != tid);

	close(fd_data);

	return true;
}

void
fatal(char *message, ...)
{
	va_list ap;

	va_start(ap, message);
	vfprintf(stderr, message, ap);
	fprintf(stderr, "\n");
	va_end(ap);

	exit(EXIT_FAILURE);
}


--------------090502090906040705090806
Content-Type: application/octet-stream;
 name="get-lcns.c.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="get-lcns.c.sig"

iD8DBQBITqcYmt9ZifioJSwRAs77AJ9JQ/0oQUOrMlH0AVYrkawEjqz7sQCeNkqapY37XDpT
sUeKyQHeqJVyNCE=
--------------090502090906040705090806
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090502090906040705090806--
