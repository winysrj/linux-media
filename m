Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:56703 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab3KDWZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 17:25:21 -0500
Received: from morden (ip-5-146-184-27.unitymediagroup.de [5.146.184.27])
	by smtp.strato.de (RZmta 32.11 DYNA|AUTH)
	with (TLSv1.2:DHE-RSA-AES256-SHA256 encrypted) ESMTPSA id n0388apA4LsJYx
	for <linux-media@vger.kernel.org>; Mon, 4 Nov 2013 23:25:18 +0100 (CET)
Received: from rjkm by morden with local (Exim 4.80)
	(envelope-from <rjkm@morden.metzler>)
	id 1VdSaD-0007H2-Vb
	for linux-media@vger.kernel.org; Mon, 04 Nov 2013 23:25:18 +0100
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21112.7885.883340.893415@morden.metzler>
Date: Mon, 4 Nov 2013 23:25:17 +0100
To: linux-media@vger.kernel.org
Subject: DVB Modulator API
In-Reply-To: <5277EBEB.4060606@dchapman.com>
References: <5277EBEB.4060606@dchapman.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Dave Chapman writes:
 > Given the recent patches by Maik Broemme adding support for a DVB-C 
 > modulator, I thought I would mention that I'm working on a driver for a 
 > DVB-T modulator and would like to open a discussion regarding how to 
 > integrate modulator support into the existing DVB API and kernel sub-system.
 > 
 > The device I'm working with is a $169 (USD) USB DVB-T modulator based on 
 > the it9507 ASIC from ITE.  ITE provide a GPL'd Linux driver, but this is 
 > 40K+ lines of code and is based on their generic cross-platform SDK 
 > supporting a range of devices.
 > 
 > The device can be purchased here in various incarnations:
 > 
 > http://www.idealez.com/hides/product-gallery/en_US/1-0/554


My driver is for this DVB-C modulator called Resi DVB-C:

http://www.digitaldevices.de/english/Resi_DVB-C_Modulator.html

It can modulate 10 DVB-C channels. They can have different modulations (QAM16
to QAM256) but have a fixed symbol rate (6.9 Msymbols) and have to 
be next to each other in one 80MHz block (10 times 8 MHz).


 > The hardware also has hardware PID filtering (allowing both whitelisting 
 > and blacklisting of data being transferred from the demod to the mod) 
 > and also the ability to insert SI packets into the modulated stream at 
 > user-definited intervals.  Again, my driver doesn't support these 
 > features yet.

The Resi does not support PID filtering but some other features like
filling up the TS with filler packets if the output rate is larger than
the rate of the TS you want to send. 
It can also correct the PCR according to the added TS packets.


 > Regarding the API, I've looked at the ddbridge driver here:
 > 
 > http://www.metzlerbros.de/dddvb/dddvb-0.9.10.tar.bz2
 > 
 > and from what I can understand, this adds a new "mod0" device to access 
 > the DVB-C modulator.  The API is as follows:
 > 
 > struct dvb_mod_params {
 > 	__u32 base_frequency;
 > 	__u32 attenuator;
 > };
 > 
 > struct dvb_mod_channel_params {
 > 	enum fe_modulation modulation;
 > 
 > 	__u32 rate_increment;
 > 	
 > };
 > 
 > #define DVB_MOD_SET              _IOW('o', 208, struct dvb_mod_params)
 > #define DVB_MOD_CHANNEL_SET      _IOW('o', 209, struct 
 > dvb_mod_channel_params)
 > 
 > I've no idea what "rate_increment" is.

It is for adjusting the the rate of filler packet insertion.
It shuld probably go into a separae ioctl. 
I could use something like your DVBMOD_SET_PARAMETERS with differnt
parameters (those for DVB-C instead of DVB-T). I just would have to 
reject most of them because only modulation can be set.


 > Looking in the docs/modulator file, there also appears to be some
 > ability to redirect data from a demod to a mod via
 > /sys/class/ddbridge/ddbridge0/redirect                                                                                                                                                                 
This is kind of a hack inside the ddbridge driver (the modulator shares the
DMA block with CI output on other ddbridge cards) which redirects
DMA from one card to another.
I am sure this can be solved more cleanly with the media controller stuff
but for now this has to suffice.
   
 
 > The it9507 driver uses a software attenuation, and the range is 
 > dependent (but only very slightly - +/- a couple of dB at either end of 
 > the scale) on the frequency.  So I've currently implemented a 
 > DVBMOD_GET_RF_GAIN_RANGE ioctl to get the available gain range for a 
 > specific frequency, but it wouldn't be a big loss to change the driver 
 > to just limit the gain to the subset that works on all frequencies, 
 > removing that call from the API.

Your DVBMOD_SET_RF_GAIN would be my attenuator setting above.


 > I haven't had chance yet to seriously consider a generic modulator API, 
 > but with one modulator driver now being considered for inclusion I 
 > wanted to make those considering the API aware of my work.
 > 
 > It seems clear however that neither my current API, nor that included 
 > with the ddbridge DVB-C modulator is generic enough at the moment.

Sure. 
We will need one generic enough to support all delivery systems and also
special hardware features like rate adjustment, PCR correction, PID filtering,
packet insertion, etc.

There are also cards which do the modulation in software and accept I/Q pairs, e.g.
the DekTec cards. But I only use those for testing demods for delivery systems
I cannot receive directly. We could add an I/Q mode for those kinds of cards.
The modulation part would have to go into user space.


Regards,
Ralph
