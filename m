Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7JHDMNW020957
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 13:13:22 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7JHD9kM013176
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 13:13:09 -0400
Received: by gv-out-0910.google.com with SMTP id n8so28402gve.13
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 10:13:08 -0700 (PDT)
From: "Henri Tuomola" <htuomola@gmail.com>
To: <video4linux-list@redhat.com>
References: <6f18c5ee0808180153h7d25999bh6c5dba01127aace7@mail.gmail.com>
	<ea4209750808180253g426b3b91m5eebf56876ba722c@mail.gmail.com>
	<000c01c9014b$667ca6f0$3375f4d0$@com>
	<003101c90219$bd1aadd0$37500970$@com>
In-Reply-To: <003101c90219$bd1aadd0$37500970$@com>
Date: Tue, 19 Aug 2008 20:12:46 +0300
Message-ID: <003901c9021e$cdc1bbb0$69453310$@com>
MIME-Version: 1.0
Content-Language: fi
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: RE: Terratec Cinergy DT XS Diversity new version
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

Hi again,

 

It seems that the patch was missing the IR receiver part. At least it was
now detected after I added the following part to dib0700_devices.c:1395.

 

.rc_interval      = DEFAULT_RC_INTERVAL,

.rc_key_map       = dib0700_rc_keys,

.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),

.rc_query         = dib0700_rc_query

 

I can send the patch later if this seems to work. Thanks for good tips
received in IRC.

 

-henri

 

From: Henri Tuomola [mailto:htuomola@gmail.com] 
Sent: 19. elokuuta 2008 19:36
To: video4linux-list@redhat.com
Subject: RE: Terratec Cinergy DT XS Diversity new version

 

Hi,

 

From: Henri Tuomola [mailto:htuomola@gmail.com] 
Sent: 18. elokuuta 2008 18:59
To: 'Albert Comerma'
Cc: video4linux-list@redhat.com
Subject: [solved] RE: Terratec Cinergy DT XS Diversity new version

 

Now I've got this: 

dib0700: loaded with support for 7 different device-types

dvb-usb: found a 'Terratec Cinergy DT USB XS Diversity' in warm state.

 

and 2 frontends.

 

thanks,

Henri

 

 

There is still one thing, the remote control is not detected. There's no
"input: IR receiver .." as was mentioned in
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity. 

 

Could this be a problem with the drivers somehow?

 

Running udevmonitor shows this:

 

UEVENT[1219163559.170764] add      /module/dvb_usb_dib0700 (module)

UDEV  [1219163559.171729] add      /module/dvb_usb_dib0700 (module)

UEVENT[1219163559.172097] add      /bus/usb/drivers/dvb_usb_dib0700
(drivers)

UEVENT[1219163559.172312] add      /class/i2c-adapter/i2c-0 (i2c-adapter)

UEVENT[1219163559.172868] add      /class/dvb/dvb0.demux0 (dvb)

UEVENT[1219163559.172888] add      /class/dvb/dvb0.dvr0 (dvb)

UEVENT[1219163559.172897] add      /class/dvb/dvb0.net0 (dvb)

UDEV  [1219163559.173953] add      /bus/usb/drivers/dvb_usb_dib0700
(drivers)

UDEV  [1219163559.174962] add      /class/i2c-adapter/i2c-0 (i2c-adapter)

UDEV  [1219163559.187748] add      /class/dvb/dvb0.demux0 (dvb)

UDEV  [1219163559.194984] add      /class/dvb/dvb0.net0 (dvb)

UDEV  [1219163559.195435] add      /class/dvb/dvb0.dvr0 (dvb)

UEVENT[1219163559.262301] add      /class/i2c-adapter/i2c-1 (i2c-adapter)

UDEV  [1219163559.263142] add      /class/i2c-adapter/i2c-1 (i2c-adapter)

UEVENT[1219163559.423124] add      /class/dvb/dvb0.frontend0 (dvb)

UDEV  [1219163559.429791] add      /class/dvb/dvb0.frontend0 (dvb)

UEVENT[1219163559.609570] add      /class/dvb/dvb1.demux0 (dvb)

UEVENT[1219163559.609608] add      /class/dvb/dvb1.dvr0 (dvb)

UEVENT[1219163559.609617] add      /class/dvb/dvb1.net0 (dvb)

UEVENT[1219163559.612643] add      /class/i2c-adapter/i2c-2 (i2c-adapter)

UDEV  [1219163559.621145] add      /class/dvb/dvb1.demux0 (dvb)

UDEV  [1219163559.630683] add      /class/dvb/dvb1.net0 (dvb)

UDEV  [1219163559.631328] add      /class/dvb/dvb1.dvr0 (dvb)

UDEV  [1219163559.631497] add      /class/i2c-adapter/i2c-2 (i2c-adapter)

UEVENT[1219163559.773190] add      /class/dvb/dvb1.frontend0 (dvb)

UDEV  [1219163559.780011] add      /class/dvb/dvb1.frontend0 (dvb)

 

 

-henri

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
