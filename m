Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:48999 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbZIDHxL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 03:53:11 -0400
Date: Fri, 4 Sep 2009 09:53:03 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: lorin@obs-besancon.fr
Cc: linux-media@vger.kernel.org
Subject: Re: Driver for webcams based on GL860 chip.
Message-ID: <20090904095303.437d3d0b@tele>
In-Reply-To: <20090901235543.7hoqudid6sg80o88@webmail.obs-besancon.fr>
References: <20090901235543.7hoqudid6sg80o88@webmail.obs-besancon.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 01 Sep 2009 23:55:43 +0200
lorin@obs-besancon.fr wrote:

> I would like to add the support for GL860 based webcams within the  
> GSPCA framework.
> 
> A patch (116KB) for that can be found at :
> http://launchpadlibrarian.net/31182405/patchu_gl860g.diff
> 
> This is not a final version, some improvement in the auto detection
> of sensor will be done. Before that I'm waiting for comments about
> what should changed in this patch in order to be accepted.
> 
> Basically there is four managed sensors so that this patch add a new  
> directory in the gspca one, it contains the main part of the driver  
> and the four sub-drivers.

Hi Olivier,

Here are some remarks:

- in gl860/gl860.h, there are complex macros. Please, use functions
  instead.

- in gl860/gl860.c

. don't change the returned values of the virtual functions as:

	static s32  sd_init(struct gspca_dev *gspca_dev);

  (should be int and not s32)

. more generally, it is a bad idea to have s32 variables.

. why are the module parameters read only? (see below)

. some initialization are unuseful as:

		static char sensor[7] = "";

. why is the video control table not static? (if some controls are not
  available for some webcams, just set gspca_dev->ctl_dis)

. in the function gl860_guess_sensor, there is

	if (product_id == 0xf191)
		sd->vsettings.sensor = ID_MI1320;

  This information could be in the device_table, and also, in the
  declaration of this table, '.driver_info = 0' is not useful.

. in the function sd_config, there is no need to set values to 0 as:

	sd->vsettings.mirrorMask = 0;

. in the same function,

	gspca_dev->alt   = 3 + 1;

  is not useful (the value will be reset at streaming start).

. in the function sd_pkt_scan, the line

	switch (*(s16 *)data) {

  may not work either with BE or LE machines.

. in the function sd_mod_init, why are the static module parameters
  moved to the variable vsettings?

. about this same variable, it should be better to set the device
  settings from the module parameters at connect time instead of at
  module load time. This permits to have different webcam types active
  at the same time...

- in the other .c files

. the use of static variables prevents to have more than one active
  webcam.

. there are values >= 0x80 in 'char' tables. These ones should be 's8'
  or 'u8' ('char' may be unsigned).

. using strings to handle binary values is less readable than simple
  hexadecimal values.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
