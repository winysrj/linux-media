Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1L3Rdx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 12:33:53 -0500
Message-ID: <4EFDF5F5.9020105@redhat.com>
Date: Fri, 30 Dec 2011 15:33:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.3 RESEND] AF9015/AF9013 changes
References: <4EF60396.4000401@iki.fi> <4EFDEBB8.1030707@redhat.com>
In-Reply-To: <4EFDEBB8.1030707@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30-12-2011 14:50, Mauro Carvalho Chehab wrote:
> On 24-12-2011 14:53, Antti Palosaari wrote:
>> Hello
>> I just looked latest for 3.3 and there was 3 patch missing I have already PULL requested.
>>
>> Could you PULL those ASAP from that tree:
>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/misc
>>
>> 2011-11-19 tda18218: fix 6 MHz default IF frequency
>> 2011-11-19 af9015: limit I2C access to keep FW happy
>> 2011-11-28 af9013: rewrite whole driver
> 
> Antti,
> 
> Please, don't send pull requests like that. They won't go to my queue, as patchwork
> won't get it.
> 
> For patchwork to get a git pull request, it has to contain the strings bellow:
> 	The following changes since commit 1a5cd29631a6b75e49e6ad8a770ab9d69cda0fa2:
> 
> 	[media] tda10021: Add support for DVB-C Annex C (2011-12-20 14:01:08 -0200)
> 
> 	are available in the git repository at:
> 	git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.3
> 
> (those are from a real example).
> 
> E. g. the pull request should be generated with git request-pull.
> 
> This time, I'll get it by hand. I'm assuming that you want me to pull from:
> 	git://linuxtv.org/anttip/media_tree.git misc
> 
> based on the URL you've sent me.

Still, the same problem as before:

drivers/media/dvb/dvb-usb/af9015.c: In function ‘af9015_rc_query’:
drivers/media/dvb/dvb-usb/af9015.c:1091:6: error: ‘adap’ undeclared (first use in this function)
drivers/media/dvb/dvb-usb/af9015.c:1091:6: note: each undeclared identifier is reported only once for each function it appears in
drivers/media/dvb/dvb-usb/af9015.c:1094:12: error: ‘struct af9015_state’ has no member named ‘sleep’
drivers/media/dvb/dvb-usb/af9015.c:1094:30: error: ‘fe’ undeclared (first use in this function)

As all patches that went to 3.1-rc7 were merged back, this means
that there's something else missing there (maybe that patch
you asked me to revert).

After digging for a while, it seems that this patch is dependent
on the one you asked me to revert:

Author: Antti Palosaari <crope@iki.fi>
Date:   Sat Nov 12 22:33:30 2011 -0300

    [media] af9015: limit I2C access to keep FW happy
    
    AF9015 firmware does not like if it gets interrupted by I2C adapter
    request on some critical phases. During normal operation I2C adapter
    is used only 2nd demodulator and tuner on dual tuner devices.
    
    Override demodulator callbacks and use mutex for limit access to
    those "critical" paths to keep AF9015 happy.
    
    Signed-off-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Applying it before this patch made it to apply. Please check if
my merge conflict didn't break anything.

Regards,
Mauro.
