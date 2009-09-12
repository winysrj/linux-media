Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv2.obs-besancon.fr ([193.52.185.12]:48289 "EHLO
	serv2.obs-besancon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZILTc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 15:32:29 -0400
Message-ID: <20090912213345.7n359quoo4w80occ@webmail.obs-besancon.fr>
Date: Sat, 12 Sep 2009 21:33:45 +0200
From: lorin@obs-besancon.fr
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: Driver for webcams based on GL860 chip.
References: <20090901235543.7hoqudid6sg80o88@webmail.obs-besancon.fr>
	<20090904095303.437d3d0b@tele>
In-Reply-To: <20090904095303.437d3d0b@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi !

>> I would like to add the support for GL860 based webcams within the
>> GSPCA framework.
>>
>> A patch (116KB) for that can be found at :
>> http://launchpadlibrarian.net/31182405/patchu_gl860g.diff
>>
>> This is not a final version, some improvement in the auto detection
>> of sensor will be done. Before that I'm waiting for comments about
>> what should changed in this patch in order to be accepted.
>>
>> Basically there is four managed sensors so that this patch add a new
>> directory in the gspca one, it contains the main part of the driver
>> and the four sub-drivers.


> Here are some remarks:
>
> - in gl860/gl860.h, there are complex macros. Please, use functions
>   instead.
Done


> - in gl860/gl860.c
>
> . don't change the returned values of the virtual functions as:
> 	static s32  sd_init(struct gspca_dev *gspca_dev);
>   (should be int and not s32)
> . more generally, it is a bad idea to have s32 variables.
I changed the returned value to int instead of s32.
There is still s32 for the control parameters.


> . why are the module parameters read only? (see below)
Properties changed to 644 instead of 444.
I discarded all parameters but sensor and AC power frequency.


> . some initialization are unuseful as:
> 		static char sensor[7] = "";
Removed with some initialisation to zero for static variables.


> . why is the video control table not static? (if some controls are not
>   available for some webcams, just set gspca_dev->ctl_dis)
It's a kind of trade-off. Control characteristics are hold in the  
sensor specific files but because of "const" the control table is  
still in the main
file. I can surely improve that.


> . in the function gl860_guess_sensor, there is
> 	if (product_id == 0xf191)
> 		sd->vsettings.sensor = ID_MI1320;
>   This information could be in the device_table, and also, in the    
> declaration of this table, '.driver_info = 0' is not useful.
Driver_info removed. I need the sensor ID in functions which not benefit from
the device table so that it is useful in the sd structure.


> . in the function sd_config, there is no need to set values to 0 as:
> 	sd->vsettings.mirrorMask = 0;
> . in the same function,
> 	gspca_dev->alt   = 3 + 1;
>   is not useful (the value will be reset at streaming start).
Removed

> . in the function sd_pkt_scan, the line
> 	switch (*(s16 *)data) {
>   may not work either with BE or LE machines.
I add a comment about the fact that only 0x0202 is checked.
May a "if" instead of the "case" could be used as I don't think any other
values will be tested.


> . in the function sd_mod_init, why are the static module parameters
>   moved to the variable vsettings?
> . about this same variable, it should be better to set the device
>   settings from the module parameters at connect time instead of at
>   module load time. This permits to have different webcam types active
>   at the same time...
Right! Old stuff no more needed. Changed.


> - in the other .c files
> . the use of static variables prevents to have more than one active
>   webcam.
Changed. Also, the byte arrays whose one byte is a control value are no more
static.


> . there are values >= 0x80 in 'char' tables. These ones should be 's8'
>   or 'u8' ('char' may be unsigned).
Changed to u8.

> . using strings to handle binary values is less readable than simple
>   hexadecimal values.
There are still there. Because these binary values are not human
understandable, I prefer the strings as they are more compact.

The improved patch is there :
http://launchpadlibrarian.net/31723472/patchu_gl860g.diff


Regards,
Olivier Lorin

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


