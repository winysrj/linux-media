Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3NJnop7001949
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 15:49:50 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3NJnXxX024002
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 15:49:33 -0400
Received: by yx-out-2324.google.com with SMTP id 8so414432yxg.81
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 12:49:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0904231013n58a64189oe1634128ac78ce09@mail.gmail.com>
References: <gspqam$n8a$1@ger.gmane.org>
	<412bdbff0904230647x8eb2b34u5ddebba380e70ade@mail.gmail.com>
	<3c722d570904230950s223927bcl8801e5f199b4eff4@mail.gmail.com>
	<412bdbff0904231013n58a64189oe1634128ac78ce09@mail.gmail.com>
From: chinmaya <chinmaya@gmail.com>
Date: Thu, 23 Apr 2009 13:49:13 -0600
Message-ID: <3c722d570904231249v1142172ct89fe5416f946aaaf@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Neal Becker <ndbecker2@gmail.com>, video4linux-list@redhat.com
Subject: Re: recommendation for hd atsc usb device?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, Apr 23, 2009 at 11:13 AM, Devin Heitmueller <
devin.heitmueller@gmail.com> wrote:

> On Thu, Apr 23, 2009 at 12:50 PM, chinmaya <chinmaya@gmail.com> wrote:
> > Just a word caution: I have not been able to get Hauppage 950q to work on
> > Ubuntu 8.10 + Mythbuntu with latest v4l-dvb code yet (both analog and
> > digital)
>
> Well, if that is the case, then it's the first I've heard of it.
> Please provide more details regarding specifically what behavior you
> are experiencing.
>
> Thanks,
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>



Hauppage 950q on Mythbuntu

.  Fresh installation of Ubuntu 8.10
.  Installed firmware as described in
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-950Q
.  Installed mythbuntu
.  Now I can tune to clear-qams and play, record
.  I decide to get latest v4l-dvb so that I would get analog support
.  I get software through mercurial, install and setup
.  I try settingup Analog.
.  Although my channel scan tunes, I could not play TV in mythfrontend
.  Now I decided to go back to Digital TV,
.  Keeping latest v4l-dvb, I delete analog device in mythbuntu and try to
tune to digital (clear-qams)
.  Nothing gets tuned


dmesg logs on 950q

[   19.347264] tveeprom 0-0050: Hauppauge model 72001, rev B3F0, serial#
6097150
[   19.347270] tveeprom 0-0050: MAC address is 00-0D-FE-5D-08-FE
[   19.347274] tveeprom 0-0050: tuner model is Xceive XC5000 (idx 150, type
76)
[   19.347278] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[   19.347281] tveeprom 0-0050: audio processor is AU8522 (idx 44)
[   19.347285] tveeprom 0-0050: decoder processor is AU8522 (idx 42)
[   19.347288] tveeprom 0-0050: has no radio, has IR receiver, has no IR
transmitter
[   19.347292] hauppauge_eeprom: hauppauge eeprom: model=72001
[   19.389744] au8522 0-0047: creating new instance
[   19.389749] au8522_decoder creating new instance...
[   19.480142] tuner 0-0061: chip found @ 0xc2 (au0828)
[   19.576582] xc5000 0-0061: creating new instance
[   19.581054] xc5000: Successfully identified at address 0x61
[   19.581062] xc5000: Firmware has not been loaded previously
[   19.585791] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
[   19.585800] firmware: requesting dvb-fe-xc5000-1.1.fw
[   19.606640] xc5000: firmware read 12332 bytes.
[   19.606644] xc5000: firmware upload
[   23.637407] usb-storage: device scan complete
[   23.640735] scsi 3:0:0:0: Direct-Access     YMAX     MagicJack
2.00 PQ: 0 ANSI: 2
[   23.643396] scsi 3:0:0:1: CD-ROM            YMAX     MagicJack
2.00 PQ: 0 ANSI: 2
[   23.649685] sd 3:0:0:0: [sdb] 36352 512-byte hardware sectors (19 MB)
[   23.652252] sd 3:0:0:0: [sdb] Write Protect is off
[   23.652256] sd 3:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   23.652260] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[   23.661435] sd 3:0:0:0: [sdb] 36352 512-byte hardware sectors (19 MB)
[   23.664252] sd 3:0:0:0: [sdb] Write Protect is off
[   23.664256] sd 3:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   23.664259] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[   23.664266]  sdb: unknown partition table
[   24.136940] sd 3:0:0:0: [sdb] Attached SCSI removable disk
[   24.137159] sd 3:0:0:0: Attached scsi generic sg2 type 0
[   24.161586] sr1: scsi3-mmc drive: 0x/0x caddy
[   24.161778] sr 3:0:0:1: Attached scsi CD-ROM sr1
[   24.161991] sr 3:0:0:1: Attached scsi generic sg3 type 5
[   27.672993] au8522 0-0047: attaching existing instance
[   27.680397] xc5000 0-0061: attaching existing instance
[   27.685178] xc5000: Successfully identified at address 0x61
[   27.685185] xc5000: Firmware has been loaded previously
[   27.685193] DVB: registering new adapter (au0828)
[   27.685201] DVB: registering adapter 0 frontend 0 (Auvitek AU8522
QAM/8VSB Frontend)...
[   27.685953] Registered device AU0828 [Hauppauge HVR950Q]
[   27.792588] usbcore: registered new interface driver au0828
[   27.841115] usbcore: registered new interface driver snd-usb-audio
[   28.453988] lp: driver loaded but no devices found
[   28.631881] Adding 2040212k swap on /dev/sda5.  Priority:-1 extents:1
across:2040212k
[   29.175301] EXT3 FS on sda7, internal journal
[   30.003933] kjournald starting.  Commit interval 5 seconds
[   30.004681] EXT3 FS on sda6, internal journal
[   30.004693] EXT3-fs: mounted filesystem with ordered data mode.


--
chinmaya sn
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
