Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51816 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDSsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 13:48:00 -0500
Received: from mfilter7-d.gandi.net (mfilter7-d.gandi.net [217.70.178.136])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 9605A41C474
	for <linux-media@vger.kernel.org>; Mon,  4 Nov 2013 19:47:57 +0100 (CET)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter7-d.gandi.net (mfilter7-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id UuB1Lqa8Xqsu for <linux-media@vger.kernel.org>;
	Mon,  4 Nov 2013 19:47:56 +0100 (CET)
Received: from [192.168.33.42] (247.Red-88-10-162.dynamicIP.rima-tde.net [88.10.162.247])
	(Authenticated sender: dave@gide.info)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPA id ECE4041C294
	for <linux-media@vger.kernel.org>; Mon,  4 Nov 2013 19:47:55 +0100 (CET)
Message-ID: <5277EBEB.4060606@dchapman.com>
Date: Mon, 04 Nov 2013 18:48:11 +0000
From: Dave Chapman <dave@dchapman.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVB Modulator API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Given the recent patches by Maik Broemme adding support for a DVB-C 
modulator, I thought I would mention that I'm working on a driver for a 
DVB-T modulator and would like to open a discussion regarding how to 
integrate modulator support into the existing DVB API and kernel sub-system.

The device I'm working with is a $169 (USD) USB DVB-T modulator based on 
the it9507 ASIC from ITE.  ITE provide a GPL'd Linux driver, but this is 
40K+ lines of code and is based on their generic cross-platform SDK 
supporting a range of devices.

The device can be purchased here in various incarnations:

http://www.idealez.com/hides/product-gallery/en_US/1-0/554

and I have been working on github here:

https://github.com/linuxstb/it9507

The original ITE driver is in the it950x_linux_v13.06.27.1 directory 
there, and my work-in-progress version is in it9507-driver.  ITE have 
also provided me with some documentation, which is in the docs directory.

Some versions of the modulator USB stick come with a demodulator (based 
on the it9133), the output of which can be sent to the modulator 
directly via a TS interface.  The it9507 also has a USB interface.

For initial simplicity (and because I don't own such a device), my 
driver only supports the modulator, but in discussing an API, it's 
obviously useful to be aware of such devices.

The hardware also has hardware PID filtering (allowing both whitelisting 
and blacklisting of data being transferred from the demod to the mod) 
and also the ability to insert SI packets into the modulated stream at 
user-definited intervals.  Again, my driver doesn't support these 
features yet.

Regarding the API, I've looked at the ddbridge driver here:

http://www.metzlerbros.de/dddvb/dddvb-0.9.10.tar.bz2

and from what I can understand, this adds a new "mod0" device to access 
the DVB-C modulator.  The API is as follows:

struct dvb_mod_params {
	__u32 base_frequency;
	__u32 attenuator;
};

struct dvb_mod_channel_params {
	enum fe_modulation modulation;

	__u32 rate_increment;
	
};

#define DVB_MOD_SET              _IOW('o', 208, struct dvb_mod_params)
#define DVB_MOD_CHANNEL_SET      _IOW('o', 209, struct 
dvb_mod_channel_params)

I've no idea what "rate_increment" is.

Looking in the docs/modulator file, there also appears to be some 
ability to redirect data from a demod to a mod via 
/sys/class/ddbridge/ddbridge0/redirect


As a comparison, the current API for my driver can be seen here:

https://github.com/linuxstb/it9507/blob/master/it9507-driver/include/dvbmod.h

My driver is currently not integrated into the DVB subsystem, and as 
such creates /dev/dvbmod%d device.  This is used for the ioctls and also 
for writing the TS to the modulator.

The it9507 driver uses a software attenuation, and the range is 
dependent (but only very slightly - +/- a couple of dB at either end of 
the scale) on the frequency.  So I've currently implemented a 
DVBMOD_GET_RF_GAIN_RANGE ioctl to get the available gain range for a 
specific frequency, but it wouldn't be a big loss to change the driver 
to just limit the gain to the subset that works on all frequencies, 
removing that call from the API.

I haven't had chance yet to seriously consider a generic modulator API, 
but with one modulator driver now being considered for inclusion I 
wanted to make those considering the API aware of my work.

It seems clear however that neither my current API, nor that included 
with the ddbridge DVB-C modulator is generic enough at the moment.

Regards,

Dave.
