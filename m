Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1JQUYp-000486-NB
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 22:27:03 +0100
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: "Albert Comerma" <albert.comerma@gmail.com>
Date: Sat, 16 Feb 2008 22:26:27 +0100
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802160638k387fba4dtd422f250fa79be7d@mail.gmail.com>
	<ea4209750802160842w28bfcd45m99308f38997c7a7a@mail.gmail.com>
In-Reply-To: <ea4209750802160842w28bfcd45m99308f38997c7a7a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802162226.27645.hfvogt@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
Reply-To: hfvogt@gmx.net
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Albert,

your dmesg-output looks absolutely fine for me (besides the already discussed xc2028 4-0061: Error on line 1063: -5
message).
Since you also obvisouly succeeded to patch the xc3028 firmware so that the scode can be loaded (which in my
cinergy did not make any noticeable difference), I still have the suspicion that the dib0700-firmware is the main reason
for your device not working.
Can you try the firmware from the Windows-driver? Comparing various dib0700-based device drivers, I found quite
different dib0700-firmware in these. I am not sure if there is any single "latest" version of the firmware which can be used
for all devices.

I have written a small tool to extract the dib0700 firmware from the Windows driver (there are probably already other/better
tools around, but I just did not find any). If you use this tool (ignore the warnings, I am still trying to understand how the
firmware is organised) and then copy the resulting firmware to the firmware-directory under the name of
dvb-usb-dib0700-1.10.fw, do you see any difference?

Good luck,
Hans-Frieder

Here comes the tool:

/*
   dib0700 firmware extraction tool
   extracts firmware for DiBcom0700(c) based devices from .sys driver files
   and stores all found firmwares in files dibfw-00.fw, dibfw-01.fw, ...

   Copyright (C) 2008 Hans-Frieder Vogt <hfvogt@gmx.net>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation version 2

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>   /* for O_RDONLY */
#include <unistd.h>  /* for open/close, ftruncate */
#include <errno.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/mman.h>


static const char fwstart[] = "\x02\x00\x00\x00\x04\x70\x00\x00";

#define MAX_FW 10
static int fwofs[MAX_FW];

int read_firmware(unsigned char *m, int idx) {
	int fd;
	int j, i = 0;
	unsigned char *buf;	/* fw is stored in junks of 22 bytes */
	char fname[20];
	unsigned char bytes, hibyte, lobyte, endflag, crcbyte;
	unsigned int crc, datapos;
	int databytes = 0;

	sprintf(fname,"dibfw-%02x.fw", idx);

	fd = open(fname, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
	if (fd < 0) {
		fprintf(stderr, "ERROR trying to open/create output file \"%s\""
			"\n", fname);
		return 1;
	}
	for (i=0;; i=i+22) {
		buf = &m[i];

		bytes = buf[0];
		lobyte = buf[2];
		hibyte = buf[3];
		endflag = buf[4];
		crcbyte = buf[21];

		/* do the checksum test */
		crc = 0;
		for (j=0; j<22; j++)
			crc += buf[j];
		if ((crc & 0xff) != 0) {
			fprintf(stderr, "ERROR: invalid line 0x%08x:\n", i);
			for (j=0; j<22; j++)
				fprintf(stderr, "0x%02x ", buf[j]);
			fprintf(stderr, "\n");
			break;
		}

		/* check whether data really fits together */
		if (i > 0) {
			datapos = lobyte | (hibyte << 8);
			if (datapos != databytes) {
				fprintf(stderr, "WARNING data inconsistent? at "
					"offset 0x%04x data written is 0x%04x, "
					"but line says 0x%04x\n", i, databytes,
					datapos);
			}
		}

		/* now write the data */
		write(fd, &bytes, 1);
		write(fd, &lobyte, 1);
		write(fd, &hibyte, 1);
		write(fd, &endflag, 1);
		write(fd, &buf[5], bytes);
		write(fd, &crcbyte, 1);
		if (i > 0) {
			databytes += bytes;
		}

		/* endflag seems to indicate the end of the firmware */
		if (endflag == 1)
			break;
	}
	close(fd);
}

int main(int argc, char **argv) {
	struct stat st;
	int fd;
	unsigned char *map;
	unsigned long map_len;
	int err;
	int i, j;
	int num_fw = 0;

	printf("%s - an extraction tool for DiBcom0700(c) firmware from W* drivers\n", 
		argv[0]);
	if (argc!=2) {
		fprintf(stderr, "%s <sys-filename>\n", argv[0]);
		return 1;
	}
	if ((err = stat(argv[1], &st) < 0)) {
		fprintf(stderr, "ERROR calling stat: %s\n", strerror (err));
		return 1;
	}
	fd = open(argv[1], O_RDONLY, 0);
	if (fd < 0) {
		fprintf(stderr, "ERROR trying to open file \"%s\"\n", argv[1]);
		return 1;
	}
	/* generate a memory map for the file */
	map = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	close (fd);

	if (map == MAP_FAILED) {
		fprintf (stderr, "ERROR calling mmap: %s\n", strerror (errno));
		return 1;
	}
	map_len = st.st_size;

	/* first search for characteristic start-string */
	for (i=0; i<map_len-8; i=i+4) {
		if ((*((unsigned int *)&map[i]) == *((unsigned int *)fwstart)) &&
		    (*((unsigned int *)&map[i+4]) == *((unsigned int *)&fwstart[4]))) {
			printf("found start of FW at 0x%08x\n", i);
			fwofs[num_fw] = i;
			num_fw++;
			if (num_fw >= MAX_FW) {
				fprintf(stderr, "WARNING: number of firmwares "
					"identified limited by compile time "
					"array size %d\n", MAX_FW);
				break;
			}
		}
	}
	if (0 == num_fw) {
		fprintf(stderr, "ERROR: did not find any firmwares in file "
			"\"%s\"\n", argv[1]);
		return 1;
	}
	for (i=0; i<num_fw; i++) {
		read_firmware(&map[fwofs[i]],i);
	}

	return 0;
}



Am Samstag, 16. Februar 2008 schrieb Albert Comerma:
> More information... I attach a dmesg of tuner-xc2028 loaded in debug mode
> while doing a scan ( scan es-Collserola|tee channels.conf ). I don't see any
> problem, but it doesn't work.
> 
> Albert
> 
> 2008/2/16, Albert Comerma <albert.comerma@gmail.com>:
> >
> > For what I understand, changing the Firmware 64 to 60000200 changes the if
> > frequency to 5.2MHz. So this modification on the firmware should make the
> > card work. What it's more strange for me is that when trying to scan no
> > signal or SNR is reported, so it seems like xc3028 firmware is not working
> > properly. Perhaps could be a wrong BASE or DTV firmware loaded?
> >
> > Albert
> >
> > 2008/2/16, Albert Comerma <albert.comerma@gmail.com>:
> > >
> > > So, If it's not a problem, any of you could send me the current xc3028
> > > firmware you are using, because mine does not seem to work... Thanks.
> > >
> > > Albert
> > >
> > > 2008/2/15, Patrick Boettcher <patrick.boettcher@desy.de>:
> > > >
> > > > Aah now I remember that issue, in fact it is no issue. I was seeing
> > > > that
> > > > problem when send the sleep command or any other firmware command
> > > > without
> > > > having a firmware running. In was, so far, no problem.
> > > >
> > > > Patrick.
> > > >
> > > >
> > > >
> > > > On Fri, 15 Feb 2008, Holger Dehnhardt wrote:
> > > >
> > > > > Hi Albert, Hi Mauro,
> > > > >
> > > > > I have successfulli patched and compiled the driver. Im using the
> > > > terratec
> > > > > cinergy device and it works fine.
> > > > >
> > > > >>> [ 2251.856000] xc2028 4-0061: Error on line 1063: -5
> > > > >
> > > > > This error message looked very familar to me, so i searched my log
> > > > and guess
> > > > > what I found:
> > > > >
> > > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> > > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> > > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: Error on line 1064: -5
> > > > > Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for
> > > > demod df75e800
> > > > > to 0
> > > > > Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for
> > > > demod df75e800
> > > > > to 0
> > > > >
> > > > > It identifies the marked line (just to be sure because of the
> > > > differen line
> > > > > numbers)
> > > > >
> > > > >       if (priv->firm_version < 0x0202)
> > > > > ->            rc = send_seq(priv, {0x00, 0x08, 0x00, 0x00});
> > > > >       else
> > > > >               rc = send_seq(priv, {0x80, 0x08, 0x00, 0x00});
> > > > >
> > > > >> The above error is really weird. It seems to be related to
> > > > something that
> > > > >> happened before xc2028, since firmware load didn't start on that
> > > > point of
> > > > >> the code.
> > > > >
> > > > > The error really is weird, but it does not seem to cause the
> > > > troubles - my
> > > > > card works despite the error!
> > > > >
> > > > >>
> > > > >>> [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0,
> > > > firmware
> > > > >>> version 2.7
> > > > >>
> > > > >> This message means that xc3028 firmware were successfully loaded
> > > > and it is
> > > > >> running ok.
> > > > >
> > > > > This and the following messages look similar...
> > > > >
> > > > > Holger
> > > > >
> > > > > _______________________________________________
> > > > > linux-dvb mailing list
> > > > > linux-dvb@linuxtv.org
> > > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > > >
> > > >
> > > > _______________________________________________
> > > > linux-dvb mailing list
> > > > linux-dvb@linuxtv.org
> > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > >
> > >
> > >
> >
> 



-- 
--
Hans-Frieder Vogt                 e-mail: hfvogt <at> gmx .dot. net

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
