Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:48266 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbbBXKPz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 05:15:55 -0500
To: =?UTF-8?Q?David_Cimb=C5=AFrek?= <david.cimburek@gmail.com>
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working  since kernel 3.17
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 24 Feb 2015 11:15:53 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Luis de Bethencourt <luis@debethencourt.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <CAEmZozMP1FFN-Y1d+7Mopy1Y9_2FjX2tJmmCne_Gpa2+_yFg0g@mail.gmail.com>
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
 <54D9E14A.5090200@iki.fi> <e65f6b905eae37f11e697ad20b97c37c@hardeman.nu>
 <CAEmZozPN2xDQMyao8GAYB1KqKxvgznn6CNc+LgPGhE=TJfDbFQ@mail.gmail.com>
 <32c10d8cd2303ed9476db1b68924170a@hardeman.nu>
 <CAEmZozP5jrJnWAF6ZbXtvkRveZE29BnSg+hO2x9KDSyPmjBBaQ@mail.gmail.com>
 <20150212095029.018f63df@recife.lan>
 <CAEmZozOTuigxavH_5M4mw5kDHS_mxgwLS53HipG2o4uvm_09OQ@mail.gmail.com>
 <20150212215700.GA4882@turing>
 <CAEmZozPKsBwq4=TtAOtR-LdjOi3k8MhmEqZ49gg8X48P1f5wdQ@mail.gmail.com>
 <CAEmZozMP1FFN-Y1d+7Mopy1Y9_2FjX2tJmmCne_Gpa2+_yFg0g@mail.gmail.com>
Message-ID: <67d0fa2066c017a66ad785dc90447d08@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-02-24 11:08, David Cimbůrek wrote:
>>> Hi,
>>> 
>>> I looked at this again and I still don't see why the order is 
>>> important.
>>> Plus the code looks like it does what it should be doing when using
>>> RC_SCANCODE_NEC, RC_SCANCODE_NEC32, RC_SCANCODE_NECX and 
>>> RC_SCANCODE_RC5.
>>> 
>>> Unfortunately I can't review this if I am not sure about it, and I 
>>> don't
>>> have the device to be able to properly test your patch.
>>> 
>>> Hopefully your print of the scancodes helps.
>>> 
>>> Luis
>> 
>> Hi,
>> 
>> unfortunately I don't understand the code very well but it really
>> works like I described.
>> 
>> I tried to get debugging output from the
>> dib0700_core.c:dib0700_rc_urb_completion() function:
>> 
>> deb_data("IR ID = %02X state = %02X System = %02X %02X Cmd = %02X %02X
>> (len %d)\n",
>>         poll_reply->report_id, poll_reply->data_state,
>>         poll_reply->system, poll_reply->not_system,
>>         poll_reply->data, poll_reply->not_data,
>>         purb->actual_length);
>> 
>> And the output after my patch (and before commit
>> af3a4a9bbeb00df3e42e77240b4cdac5479812f9!) looks like this:
>> 
>> [  282.842557] IR ID = 01 state = 01 System = 07 00 Cmd = 0F F0 (len 
>> 6)
>> [  282.955810] IR ID = 01 state = 02 System = 07 00 Cmd = 0F F0 (len 
>> 6)
>> 
>> But without my patch the output looks after commit
>> af3a4a9bbeb00df3e42e77240b4cdac5479812f9 like this:
>> 
>> [  186.302282] IR ID = 01 state = 01 System = 00 07 Cmd = 0F F0 (len 
>> 6)
>> [  186.415660] IR ID = 01 state = 02 System = 00 07 Cmd = 0F F0 (len 
>> 6)
>> 
>> You can see that the content of "system" and "not_system" is really 
>> switched...
>> 
>> Regards,
>> David
> 
> Is there anything more I can do? Shall I provide some more debugging
> outputs? There is no response nearly for two weeks...

Sorry, I'm just really busy.

The output that you gave (the actual scancodes that are generated) is 
what I was looking for, not the keymap. If I remember correctly my patch 
wasn't supposed to change the generated scancodes (or the keymap would 
have to be changed as well).

The question is whether the right thing to do is to change back the 
scancode calculation or to update the keymap. I'll try to have a closer 
look as soon as possible (which might take a few days more, sorry).

Re,
David

