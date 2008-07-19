Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6J9DXbL030990
	for <video4linux-list@redhat.com>; Sat, 19 Jul 2008 05:13:33 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6J9DLZI032239
	for <video4linux-list@redhat.com>; Sat, 19 Jul 2008 05:13:21 -0400
Message-ID: <4881B205.803@hhs.nl>
Date: Sat, 19 Jul 2008 11:21:09 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
References: <4881A0E9.70607@free.fr>
In-Reply-To: <4881A0E9.70607@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [RFC] webcam sensor module
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

Thierry Merle wrote:
> Hello all,
> While analyzing the w9968cf v4l1 module, I saw that my webcam commands a OV7620 sensor. This sensor has a specific module: ovcamchip (v4l1).
> My webcam is a Creative Webcam Go Plus.
> 
> In gspca, the zc3xx driver addresses the same sensor, but in only one module containing USB bridge controls and sensor controls.
> 
> My question is: why gspca does not use the same infrastructure? I mean 1 module for the USB bridge (like w9968cf) and 1 module for the sensor (like ovcamchip).
> My first thought was to re-write w9968cf in the gspca frame but I wanted to keep this modular way of life.

I've been thinking about this in the past too and looking at how the various 
(wildly different) usb webcam driver we have so far handle this.

The problem is that the "marriage" between the bridge and the sensor is a quite 
close one, both often come with various registers which allow them to work with 
a variety of sensors (in the case of bridges) / bridges (in the case of sensors).

So quite often only the v4l control code for things like setting brightness in 
the sensor could be shared. A problem here is that the v4l2 control code needs 
a way to access the sensor registers to the bridge. Some current code solves 
this by exporting an i2c interface, but this isn't always correct, bridges / 
sensors talk to each other in a variety of ways, including but not limited to i2c.

All in all since most of the sensor init code will be bridge specific anyway 
(what kind of hsync / vsync pulses does the bridge want, which pixel format, 
how many bits to transfer at a time 4 / 8 / 10, etc.) its easy to just bundle 
all the sensor specific code with the bridge code.

Splitting the code to handle a sensor in 2 parts, 1 bridge specific, 1 generic 
for the sensor with all bridges, only makes the code harder to understand with 
very little benefit as the few shared pieces of code are often no more then 
poking a single register directly writing a v4l2 ctrl value to it.

To give you an idea, the sn9c102 driver, which uses seperate per sensor 
sub-drivers, currently in the mainline counts 2477 lines in the relevant 
per-sensor sub-drivers to support the 7 sensors that the gspca sonixb driver 
also supports. The gspca sonixb subdriver counts 922 lines in total, including 
support for the bridge!! and for those 7 sensors.

To give you another idea, the zc0301 and the sn9c102 drivers both written by 
Luca Risolia using the same structure, both use sensor specific subdrivers.
Even though these have the code split in sensor specific and bridge generic 
code, they do not share their sensor drivers. They do support some of the same 
sensors though, for example the pas202b. No lets compare the sensor subdrivers 
for the pas between the zc0301 and sn9c102:
[hans@localhost video]$ diff -u zc0301/zc0301_pas202bcb.c 
sn9c102/sn9c102_pas202bcb.c > diff
[hans@localhost video]$ diffstat diff
  sn9c102_pas202bcb.c |  351 ++++++++++++++++++++++++----------------------------
  1 file changed, 162 insertions(+), 189 deletions(-)
[hans@localhost video]$ wc -l zc0301/zc0301_pas202bcb.c
362 zc0301/zc0301_pas202bcb.c

So in other words, about 170 lines have changed of a 360 line file to support a 
different bridge, and this is not due to subtle differences like different 
indentation I've checked the diff output.

If you look the not changed lines basicly only the list of supported v4l2 
controls, the get_v4l2_ctrl and set_v4l2_ctrl code is unchanged.

Checking all gspca sub drivers, currently there are 47 different sensors (not 
counting the chips were sensor and bridge are one) of those 47 sensors only 9 
get used with more then one bridge. So in the overwelming majority of cases 
there is a 1 on 1 relation between bridge and sensor.

Also keep in mind that most of the drivers in gspca are reverse engineered, 
quite a few just replay a bunch of captured usb control messages as 
initialization without even knowing which control messages go to the bridge and 
which poke sensor registers through the bridge.

So all in all I believe separating this is not worth it, the additional 
complexity and lines needed are more then we have to gain. See the sonixb 
versus sn9x102 driver for example.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
