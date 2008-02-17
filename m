Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JQiPs-0005vR-0n
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 13:14:44 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1005581fge.25
	for <linux-dvb@linuxtv.org>; Sun, 17 Feb 2008 04:14:43 -0800 (PST)
Message-ID: <ea4209750802170414n6e4f82dam4c6908536b695033@mail.gmail.com>
Date: Sun, 17 Feb 2008 13:14:42 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: hfvogt@gmx.net
In-Reply-To: <200802162226.27645.hfvogt@gmx.net>
MIME-Version: 1.0
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802160638k387fba4dtd422f250fa79be7d@mail.gmail.com>
	<ea4209750802160842w28bfcd45m99308f38997c7a7a@mail.gmail.com>
	<200802162226.27645.hfvogt@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0722938161=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0722938161==
Content-Type: multipart/alternative;
	boundary="----=_Part_19346_28348046.1203250482936"

------=_Part_19346_28348046.1203250482936
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi hans, thanks for the idea, but the result is the same. I extracted the
firmware for the windows driver using your tool and when I use it, it seems
to work except for a repeating message of;
 dvb-usb: error while querying for an remote control event.
I think they have an other .sys for the remote control management firmware.
But when I try to scan the dmesg is exactly the same as before, everything
seems correct, but there's no signal / SNR. I don't know if this could be a
different GPIO used or different i2c or something like that, because the
rest seems correct.

Albert

2008/2/16, Hans-Frieder Vogt <hfvogt@gmx.net>:
>
> Albert,
>
> your dmesg-output looks absolutely fine for me (besides the already
> discussed xc2028 4-0061: Error on line 1063: -5
> message).
> Since you also obvisouly succeeded to patch the xc3028 firmware so that
> the scode can be loaded (which in my
> cinergy did not make any noticeable difference), I still have the
> suspicion that the dib0700-firmware is the main reason
> for your device not working.
> Can you try the firmware from the Windows-driver? Comparing various
> dib0700-based device drivers, I found quite
> different dib0700-firmware in these. I am not sure if there is any single
> "latest" version of the firmware which can be used
> for all devices.
>
> I have written a small tool to extract the dib0700 firmware from the
> Windows driver (there are probably already other/better
> tools around, but I just did not find any). If you use this tool (ignore
> the warnings, I am still trying to understand how the
> firmware is organised) and then copy the resulting firmware to the
> firmware-directory under the name of
> dvb-usb-dib0700-1.10.fw, do you see any difference?
>
> Good luck,
> Hans-Frieder
>
> Here comes the tool:
>
> /*
>    dib0700 firmware extraction tool
>    extracts firmware for DiBcom0700(c) based devices from .sys driver
> files
>    and stores all found firmwares in files dibfw-00.fw, dibfw-01.fw, ...
>
>    Copyright (C) 2008 Hans-Frieder Vogt <hfvogt@gmx.net>
>
>    This program is free software; you can redistribute it and/or modify
>    it under the terms of the GNU General Public License as published by
>    the Free Software Foundation version 2
>
>    This program is distributed in the hope that it will be useful,
>    but WITHOUT ANY WARRANTY; without even the implied warranty of
>    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>    GNU General Public License for more details.
>
>    You should have received a copy of the GNU General Public License
>    along with this program; if not, write to the Free Software
>    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
> #include <stdio.h>
> #include <stdlib.h>
> #include <fcntl.h>   /* for O_RDONLY */
> #include <unistd.h>  /* for open/close, ftruncate */
> #include <errno.h>
> #include <string.h>
> #include <sys/stat.h>
> #include <sys/mman.h>
>
>
> static const char fwstart[] = "\x02\x00\x00\x00\x04\x70\x00\x00";
>
> #define MAX_FW 10
> static int fwofs[MAX_FW];
>
> int read_firmware(unsigned char *m, int idx) {
>         int fd;
>         int j, i = 0;
>         unsigned char *buf;     /* fw is stored in junks of 22 bytes */
>         char fname[20];
>         unsigned char bytes, hibyte, lobyte, endflag, crcbyte;
>         unsigned int crc, datapos;
>         int databytes = 0;
>
>         sprintf(fname,"dibfw-%02x.fw", idx);
>
>         fd = open(fname, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
>         if (fd < 0) {
>                 fprintf(stderr, "ERROR trying to open/create output file
> \"%s\""
>                         "\n", fname);
>                 return 1;
>         }
>         for (i=0;; i=i+22) {
>                 buf = &m[i];
>
>                 bytes = buf[0];
>                 lobyte = buf[2];
>                 hibyte = buf[3];
>                 endflag = buf[4];
>                 crcbyte = buf[21];
>
>                 /* do the checksum test */
>                 crc = 0;
>                 for (j=0; j<22; j++)
>                         crc += buf[j];
>                 if ((crc & 0xff) != 0) {
>                         fprintf(stderr, "ERROR: invalid line 0x%08x:\n",
> i);
>                         for (j=0; j<22; j++)
>                                 fprintf(stderr, "0x%02x ", buf[j]);
>                         fprintf(stderr, "\n");
>                         break;
>                 }
>
>                 /* check whether data really fits together */
>                 if (i > 0) {
>                         datapos = lobyte | (hibyte << 8);
>                         if (datapos != databytes) {
>                                 fprintf(stderr, "WARNING data
> inconsistent? at "
>                                         "offset 0x%04x data written is
> 0x%04x, "
>                                         "but line says 0x%04x\n", i,
> databytes,
>                                         datapos);
>                         }
>                 }
>
>                 /* now write the data */
>                 write(fd, &bytes, 1);
>                 write(fd, &lobyte, 1);
>                 write(fd, &hibyte, 1);
>                 write(fd, &endflag, 1);
>                 write(fd, &buf[5], bytes);
>                 write(fd, &crcbyte, 1);
>                 if (i > 0) {
>                         databytes += bytes;
>                 }
>
>                 /* endflag seems to indicate the end of the firmware */
>                 if (endflag == 1)
>                         break;
>         }
>         close(fd);
> }
>
> int main(int argc, char **argv) {
>         struct stat st;
>         int fd;
>         unsigned char *map;
>         unsigned long map_len;
>         int err;
>         int i, j;
>         int num_fw = 0;
>
>         printf("%s - an extraction tool for DiBcom0700(c) firmware from W*
> drivers\n",
>                 argv[0]);
>         if (argc!=2) {
>                 fprintf(stderr, "%s <sys-filename>\n", argv[0]);
>                 return 1;
>         }
>         if ((err = stat(argv[1], &st) < 0)) {
>                 fprintf(stderr, "ERROR calling stat: %s\n", strerror
> (err));
>                 return 1;
>         }
>         fd = open(argv[1], O_RDONLY, 0);
>         if (fd < 0) {
>                 fprintf(stderr, "ERROR trying to open file \"%s\"\n",
> argv[1]);
>                 return 1;
>         }
>         /* generate a memory map for the file */
>         map = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
>         close (fd);
>
>         if (map == MAP_FAILED) {
>                 fprintf (stderr, "ERROR calling mmap: %s\n", strerror
> (errno));
>                 return 1;
>         }
>         map_len = st.st_size;
>
>         /* first search for characteristic start-string */
>         for (i=0; i<map_len-8; i=i+4) {
>                 if ((*((unsigned int *)&map[i]) == *((unsigned int
> *)fwstart)) &&
>                     (*((unsigned int *)&map[i+4]) == *((unsigned int
> *)&fwstart[4]))) {
>                         printf("found start of FW at 0x%08x\n", i);
>                         fwofs[num_fw] = i;
>                         num_fw++;
>                         if (num_fw >= MAX_FW) {
>                                 fprintf(stderr, "WARNING: number of
> firmwares "
>                                         "identified limited by compile
> time "
>                                         "array size %d\n", MAX_FW);
>                                 break;
>                         }
>                 }
>         }
>         if (0 == num_fw) {
>                 fprintf(stderr, "ERROR: did not find any firmwares in file
> "
>                         "\"%s\"\n", argv[1]);
>                 return 1;
>         }
>         for (i=0; i<num_fw; i++) {
>                 read_firmware(&map[fwofs[i]],i);
>         }
>
>         return 0;
> }
>
>
>
> Am Samstag, 16. Februar 2008 schrieb Albert Comerma:
>
> > More information... I attach a dmesg of tuner-xc2028 loaded in debug
> mode
> > while doing a scan ( scan es-Collserola|tee channels.conf ). I don't see
> any
> > problem, but it doesn't work.
> >
> > Albert
> >
> > 2008/2/16, Albert Comerma <albert.comerma@gmail.com>:
> > >
> > > For what I understand, changing the Firmware 64 to 60000200 changes
> the if
> > > frequency to 5.2MHz. So this modification on the firmware should make
> the
> > > card work. What it's more strange for me is that when trying to scan
> no
> > > signal or SNR is reported, so it seems like xc3028 firmware is not
> working
> > > properly. Perhaps could be a wrong BASE or DTV firmware loaded?
> > >
> > > Albert
> > >
> > > 2008/2/16, Albert Comerma <albert.comerma@gmail.com>:
> > > >
> > > > So, If it's not a problem, any of you could send me the current
> xc3028
> > > > firmware you are using, because mine does not seem to work...
> Thanks.
> > > >
> > > > Albert
> > > >
> > > > 2008/2/15, Patrick Boettcher <patrick.boettcher@desy.de>:
> > > > >
> > > > > Aah now I remember that issue, in fact it is no issue. I was
> seeing
> > > > > that
> > > > > problem when send the sleep command or any other firmware command
> > > > > without
> > > > > having a firmware running. In was, so far, no problem.
> > > > >
> > > > > Patrick.
> > > > >
> > > > >
> > > > >
> > > > > On Fri, 15 Feb 2008, Holger Dehnhardt wrote:
> > > > >
> > > > > > Hi Albert, Hi Mauro,
> > > > > >
> > > > > > I have successfulli patched and compiled the driver. Im using
> the
> > > > > terratec
> > > > > > cinergy device and it works fine.
> > > > > >
> > > > > >>> [ 2251.856000] xc2028 4-0061: Error on line 1063: -5
> > > > > >
> > > > > > This error message looked very familar to me, so i searched my
> log
> > > > > and guess
> > > > > > what I found:
> > > > > >
> > > > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> > > > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> > > > > > Feb 15 20:42:18 musik kernel: xc2028 3-0061: Error on line 1064:
> -5
> > > > > > Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for
> > > > > demod df75e800
> > > > > > to 0
> > > > > > Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for
> > > > > demod df75e800
> > > > > > to 0
> > > > > >
> > > > > > It identifies the marked line (just to be sure because of the
> > > > > differen line
> > > > > > numbers)
> > > > > >
> > > > > >       if (priv->firm_version < 0x0202)
> > > > > > ->            rc = send_seq(priv, {0x00, 0x08, 0x00, 0x00});
> > > > > >       else
> > > > > >               rc = send_seq(priv, {0x80, 0x08, 0x00, 0x00});
> > > > > >
> > > > > >> The above error is really weird. It seems to be related to
> > > > > something that
> > > > > >> happened before xc2028, since firmware load didn't start on
> that
> > > > > point of
> > > > > >> the code.
> > > > > >
> > > > > > The error really is weird, but it does not seem to cause the
> > > > > troubles - my
> > > > > > card works despite the error!
> > > > > >
> > > > > >>
> > > > > >>> [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version
> 1.0,
> > > > > firmware
> > > > > >>> version 2.7
> > > > > >>
> > > > > >> This message means that xc3028 firmware were successfully
> loaded
> > > > > and it is
> > > > > >> running ok.
> > > > > >
> > > > > > This and the following messages look similar...
> > > > > >
> > > > > > Holger
> > > > > >
> > > > > > _______________________________________________
> > > > > > linux-dvb mailing list
> > > > > > linux-dvb@linuxtv.org
> > > > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > > > >
> > > > >
> > > > > _______________________________________________
> > > > > linux-dvb mailing list
> > > > > linux-dvb@linuxtv.org
> > > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > > >
> > > >
> > > >
> > >
> >
>
>
>
>
> --
> --
> Hans-Frieder Vogt                 e-mail: hfvogt <at> gmx .dot. net
>

------=_Part_19346_28348046.1203250482936
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi hans, thanks for the idea, but the result is the same. I extracted the f=
irmware for the windows driver using your tool and when I use it, it seems =
to work except for a repeating message of;<br>&nbsp;dvb-usb: error while qu=
erying for an remote control event. <br>
I think they have an other .sys for the remote control management firmware.=
<br>But when I try to scan the dmesg is exactly the same as before, everyth=
ing seems correct, but there&#39;s no signal / SNR. I don&#39;t know if thi=
s could be a different GPIO used or different i2c or something like that, b=
ecause the rest seems correct.<br>
<br>Albert<br><br><div><span class=3D"gmail_quote">2008/2/16, Hans-Frieder =
Vogt &lt;<a href=3D"mailto:hfvogt@gmx.net">hfvogt@gmx.net</a>&gt;:</span><b=
lockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 20=
4, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Albert,<br> <br> your dmesg-output looks absolutely fine for me (besides th=
e already discussed xc2028 4-0061: Error on line 1063: -5<br> message).<br>=
 Since you also obvisouly succeeded to patch the xc3028 firmware so that th=
e scode can be loaded (which in my<br>
 cinergy did not make any noticeable difference), I still have the suspicio=
n that the dib0700-firmware is the main reason<br> for your device not work=
ing.<br> Can you try the firmware from the Windows-driver? Comparing variou=
s dib0700-based device drivers, I found quite<br>
 different dib0700-firmware in these. I am not sure if there is any single =
&quot;latest&quot; version of the firmware which can be used<br> for all de=
vices.<br> <br> I have written a small tool to extract the dib0700 firmware=
 from the Windows driver (there are probably already other/better<br>
 tools around, but I just did not find any). If you use this tool (ignore t=
he warnings, I am still trying to understand how the<br> firmware is organi=
sed) and then copy the resulting firmware to the firmware-directory under t=
he name of<br>
 dvb-usb-dib0700-1.10.fw, do you see any difference?<br> <br> Good luck,<br=
> Hans-Frieder<br> <br> Here comes the tool:<br> <br> /*<br>&nbsp;&nbsp; di=
b0700 firmware extraction tool<br>&nbsp;&nbsp; extracts firmware for DiBcom=
0700(c) based devices from .sys driver files<br>
&nbsp;&nbsp; and stores all found firmwares in files dibfw-00.fw, dibfw-01.=
fw, ...<br> <br>&nbsp;&nbsp; Copyright (C) 2008 Hans-Frieder Vogt &lt;<a hr=
ef=3D"mailto:hfvogt@gmx.net">hfvogt@gmx.net</a>&gt;<br> <br>&nbsp;&nbsp; Th=
is program is free software; you can redistribute it and/or modify<br>
&nbsp;&nbsp; it under the terms of the GNU General Public License as publis=
hed by<br>&nbsp;&nbsp; the Free Software Foundation version 2<br> <br>&nbsp=
;&nbsp; This program is distributed in the hope that it will be useful,<br>=
&nbsp;&nbsp; but WITHOUT ANY WARRANTY; without even the implied warranty of=
<br>
&nbsp;&nbsp; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.&nbsp;&nbs=
p;See the<br>&nbsp;&nbsp; GNU General Public License for more details.<br> =
<br>&nbsp;&nbsp; You should have received a copy of the GNU General Public =
License<br>&nbsp;&nbsp; along with this program; if not, write to the Free =
Software<br>
&nbsp;&nbsp; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.<br>&=
nbsp;&nbsp;*/<br> #include &lt;stdio.h&gt;<br> #include &lt;stdlib.h&gt;<br=
> #include &lt;fcntl.h&gt;&nbsp;&nbsp; /* for O_RDONLY */<br> #include &lt;=
unistd.h&gt;&nbsp;&nbsp;/* for open/close, ftruncate */<br>
 #include &lt;errno.h&gt;<br> #include &lt;string.h&gt;<br> #include &lt;sy=
s/stat.h&gt;<br> #include &lt;sys/mman.h&gt;<br> <br> <br> static const cha=
r fwstart[] =3D &quot;\x02\x00\x00\x00\x04\x70\x00\x00&quot;;<br> <br> #def=
ine MAX_FW 10<br>
 static int fwofs[MAX_FW];<br> <br> int read_firmware(unsigned char *m, int=
 idx) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int fd;<br>&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int j, i =3D 0;<br>&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;unsigned char *buf;&nbsp;&nbsp;&nbsp;&nb=
sp; /* fw is stored in junks of 22 bytes */<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;char fname[20];<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;unsigned char bytes, hibyte=
, lobyte, endflag, crcbyte;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;unsigned int crc, datapos;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;int databytes =3D 0;<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;sprintf(fname,&quot;dibfw-%02x.fw&quot;, idx);<br> <br>&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fd =3D open(fname, O_WRONLY | O_CREAT,=
 S_IRUSR | S_IWUSR);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (fd &lt; 0) {<br>&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;fprintf(stderr, &quot;ERROR trying to open/create output file=
 \&quot;%s\&quot;&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&quot;\n&quot;, fname);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return=
 1;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for (i=3D0;; i=3Di+22) {<br=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;buf =3D &amp;m[i];<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bytes=
 =3D buf[0];<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;lobyte =3D buf[2];<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;hibyte =3D buf[3];<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;endflag =3D buf[4];<br>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;crcbyte =3D buf[21];<br>
 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;/* do the checksum test */<br>&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;crc =3D 0;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for (j=3D0; j&lt;22; j++)<br>&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;crc +=3D buf[j]=
;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;if ((crc &amp; 0xff) !=3D 0) {<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, &quot=
;ERROR: invalid line 0x%08x:\n&quot;, i);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for (j=
=3D0; j&lt;22; j++)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fprintf(st=
derr, &quot;0x%02x &quot;, buf[j]);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, &quot;\n&quot;);<br>&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;}<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/* check whether data r=
eally fits together */<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (i &gt; 0) {<br>&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;datapos =3D lob=
yte | (hibyte &lt;&lt; 8);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;if (datapos !=3D databytes) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, &quot;WARNING dat=
a inconsistent? at &quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;offset 0x%04x data writte=
n is 0x%04x, &quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;but line says 0x%04x\n&quot;, i=
, databytes,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;datapos);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br> <br>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;/* now write the data */<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;write(fd, &amp;bytes, =
1);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;write(fd, &amp;lobyte, 1);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;write(fd, &amp;hibyte, 1);<br>&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wri=
te(fd, &amp;endflag, 1);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;write(fd, &amp;buf[5], byt=
es);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;write(fd, &amp;crcbyte, 1);<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;if (i &gt; 0) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;databy=
tes +=3D bytes;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/* e=
ndflag seems to indicate the end of the firmware */<br>&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;if (endflag =3D=3D 1)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;break;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;close(fd);<br> }<br> <br> i=
nt main(int argc, char **argv) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;struct stat st;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;int fd;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;unsigned char *=
map;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;unsigned long map_l=
en;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int err;<br>&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int i, j;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int num_fw =3D 0;<br> <br>&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;printf(&quot;%s - an extract=
ion tool for DiBcom0700(c) firmware from W* drivers\n&quot;,<br>&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;argv[0]);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (=
argc!=3D2) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, &quot;%s &lt;sys-filen=
ame&gt;\n&quot;, argv[0]);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;return 1;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if ((err =3D st=
at(argv[1], &amp;st) &lt; 0)) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, &qu=
ot;ERROR calling stat: %s\n&quot;, strerror (err));<br>&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;return 1;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fd =3D open(argv[1], O_RDON=
LY, 0);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (fd &lt; 0) {=
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, &quot;ERROR trying to open file \&=
quot;%s\&quot;\n&quot;, argv[1]);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return 1;<br>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;/* generate a memory map for the file */<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;map =3D mmap(NULL, st.st_si=
ze, PROT_READ, MAP_PRIVATE, fd, 0);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;close (fd);<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;if (map =3D=3D MAP_FAILED) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fprintf (stderr, =
&quot;ERROR calling mmap: %s\n&quot;, strerror (errno));<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;return 1;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;map_len =3D st.=
st_size;<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/* first s=
earch for characteristic start-string */<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;for (i=3D0; i&lt;map_len-8; i=3Di+4) {<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;if ((*((unsigned int *)&amp;map[i]) =3D=3D *((unsigned int *)fwstart))=
 &amp;&amp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(*((unsigned int *)&amp;map[i+=
4]) =3D=3D *((unsigned int *)&amp;fwstart[4]))) {<br>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;printf(&quot;found start of =
FW at 0x%08x\n&quot;, i);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;fwofs[num_fw] =3D i;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;num_fw=
++;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;if (num_fw &gt;=3D MAX_FW) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
fprintf(stderr, &quot;WARNING: number of firmwares &quot;<br>&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&quot;identified limited by compile time &quot;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&quot;array size %d\n&quot;, MAX_FW);<br>&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;break;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;if (0 =3D=3D num_fw) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, &qu=
ot;ERROR: did not find any firmwares in file &quot;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;=
\&quot;%s\&quot;\n&quot;, argv[1]);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return 1;<br>&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;for (i=3D0; i&lt;num_fw; i++) {<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;read_firmware(&amp;map[fwofs[i]],i);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;}<br>
 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return 0;<br> }<br> <b=
r> <br> <br> Am Samstag, 16. Februar 2008 schrieb Albert Comerma:<br> <br>&=
gt; More information... I attach a dmesg of tuner-xc2028 loaded in debug mo=
de<br> &gt; while doing a scan ( scan es-Collserola|tee channels.conf ). I =
don&#39;t see any<br>
 &gt; problem, but it doesn&#39;t work.<br> &gt;<br> &gt; Albert<br> &gt;<b=
r> &gt; 2008/2/16, Albert Comerma &lt;<a href=3D"mailto:albert.comerma@gmai=
l.com">albert.comerma@gmail.com</a>&gt;:<br> &gt; &gt;<br> &gt; &gt; For wh=
at I understand, changing the Firmware 64 to 60000200 changes the if<br>
 &gt; &gt; frequency to 5.2MHz. So this modification on the firmware should=
 make the<br> &gt; &gt; card work. What it&#39;s more strange for me is tha=
t when trying to scan no<br> &gt; &gt; signal or SNR is reported, so it see=
ms like xc3028 firmware is not working<br>
 &gt; &gt; properly. Perhaps could be a wrong BASE or DTV firmware loaded?<=
br> &gt; &gt;<br> &gt; &gt; Albert<br> &gt; &gt;<br> &gt; &gt; 2008/2/16, A=
lbert Comerma &lt;<a href=3D"mailto:albert.comerma@gmail.com">albert.comerm=
a@gmail.com</a>&gt;:<br>
 &gt; &gt; &gt;<br> &gt; &gt; &gt; So, If it&#39;s not a problem, any of yo=
u could send me the current xc3028<br> &gt; &gt; &gt; firmware you are usin=
g, because mine does not seem to work... Thanks.<br> &gt; &gt; &gt;<br>
 &gt; &gt; &gt; Albert<br> &gt; &gt; &gt;<br> &gt; &gt; &gt; 2008/2/15, Pat=
rick Boettcher &lt;<a href=3D"mailto:patrick.boettcher@desy.de">patrick.boe=
ttcher@desy.de</a>&gt;:<br> &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; Aah=
 now I remember that issue, in fact it is no issue. I was seeing<br>
 &gt; &gt; &gt; &gt; that<br> &gt; &gt; &gt; &gt; problem when send the sle=
ep command or any other firmware command<br> &gt; &gt; &gt; &gt; without<br=
> &gt; &gt; &gt; &gt; having a firmware running. In was, so far, no problem=
.<br>
 &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; Patrick.<br> &gt; &gt; &gt; &g=
t;<br> &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; =
On Fri, 15 Feb 2008, Holger Dehnhardt wrote:<br> &gt; &gt; &gt; &gt;<br>
 &gt; &gt; &gt; &gt; &gt; Hi Albert, Hi Mauro,<br> &gt; &gt; &gt; &gt; &gt;=
<br> &gt; &gt; &gt; &gt; &gt; I have successfulli patched and compiled the =
driver. Im using the<br> &gt; &gt; &gt; &gt; terratec<br> &gt; &gt; &gt; &g=
t; &gt; cinergy device and it works fine.<br>
 &gt; &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; &gt;&gt;&gt; [ 2251.85600=
0] xc2028 4-0061: Error on line 1063: -5<br> &gt; &gt; &gt; &gt; &gt;<br> &=
gt; &gt; &gt; &gt; &gt; This error message looked very familar to me, so i =
searched my log<br>
 &gt; &gt; &gt; &gt; and guess<br> &gt; &gt; &gt; &gt; &gt; what I found:<b=
r> &gt; &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; &gt; Feb 15 20:42:18 mu=
sik kernel: xc2028 3-0061: xc2028_sleep called<br> &gt; &gt; &gt; &gt; &gt;=
 Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called<br>
 &gt; &gt; &gt; &gt; &gt; Feb 15 20:42:18 musik kernel: xc2028 3-0061: Erro=
r on line 1064: -5<br> &gt; &gt; &gt; &gt; &gt; Feb 15 20:42:18 musik kerne=
l: DiB7000P: setting output mode for<br> &gt; &gt; &gt; &gt; demod df75e800=
<br>
 &gt; &gt; &gt; &gt; &gt; to 0<br> &gt; &gt; &gt; &gt; &gt; Feb 15 20:42:18=
 musik kernel: DiB7000P: setting output mode for<br> &gt; &gt; &gt; &gt; de=
mod df75e800<br> &gt; &gt; &gt; &gt; &gt; to 0<br> &gt; &gt; &gt; &gt; &gt;=
<br>
 &gt; &gt; &gt; &gt; &gt; It identifies the marked line (just to be sure be=
cause of the<br> &gt; &gt; &gt; &gt; differen line<br> &gt; &gt; &gt; &gt; =
&gt; numbers)<br> &gt; &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; &gt;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (priv-&gt;firm_version &lt; 0x0202)<br>
 &gt; &gt; &gt; &gt; &gt; -&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;rc =3D send_seq(priv, {0x00, 0x08, 0x00, 0x00})=
;<br> &gt; &gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else<br>=
 &gt; &gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rc =3D send_seq(priv, {0x80, 0x08, 0x00,=
 0x00});<br>
 &gt; &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; &gt;&gt; The above error =
is really weird. It seems to be related to<br> &gt; &gt; &gt; &gt; somethin=
g that<br> &gt; &gt; &gt; &gt; &gt;&gt; happened before xc2028, since firmw=
are load didn&#39;t start on that<br>
 &gt; &gt; &gt; &gt; point of<br> &gt; &gt; &gt; &gt; &gt;&gt; the code.<br=
> &gt; &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; &gt; The error really is=
 weird, but it does not seem to cause the<br> &gt; &gt; &gt; &gt; troubles =
- my<br>
 &gt; &gt; &gt; &gt; &gt; card works despite the error!<br> &gt; &gt; &gt; =
&gt; &gt;<br> &gt; &gt; &gt; &gt; &gt;&gt;<br> &gt; &gt; &gt; &gt; &gt;&gt;=
&gt; [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0,<br>
 &gt; &gt; &gt; &gt; firmware<br> &gt; &gt; &gt; &gt; &gt;&gt;&gt; version =
2.7<br> &gt; &gt; &gt; &gt; &gt;&gt;<br> &gt; &gt; &gt; &gt; &gt;&gt; This =
message means that xc3028 firmware were successfully loaded<br> &gt; &gt; &=
gt; &gt; and it is<br>
 &gt; &gt; &gt; &gt; &gt;&gt; running ok.<br> &gt; &gt; &gt; &gt; &gt;<br> =
&gt; &gt; &gt; &gt; &gt; This and the following messages look similar...<br=
> &gt; &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt; &gt; Holger<br> &gt; &gt=
; &gt; &gt; &gt;<br>
 &gt; &gt; &gt; &gt; &gt; _______________________________________________<b=
r> &gt; &gt; &gt; &gt; &gt; linux-dvb mailing list<br> &gt; &gt; &gt; &gt; =
&gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
 &gt; &gt; &gt; &gt; &gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman=
/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-=
dvb</a><br> &gt; &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt; &gt;<br> &gt; &gt; =
&gt; &gt; _______________________________________________<br>
 &gt; &gt; &gt; &gt; linux-dvb mailing list<br> &gt; &gt; &gt; &gt; <a href=
=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br> &gt; &gt; &=
gt; &gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-d=
vb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
 &gt; &gt; &gt; &gt;<br> &gt; &gt; &gt;<br> &gt; &gt; &gt;<br> &gt; &gt;<br=
> &gt;<br> <br> <br> <br> <br>--<br> --<br> Hans-Frieder Vogt&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; e-mail: hfvogt &lt;at&gt; gmx .dot. net<br> </blockquote></div><br>

------=_Part_19346_28348046.1203250482936--


--===============0722938161==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0722938161==--
