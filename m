Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:45902 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaICKib (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 06:38:31 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBB002O0MW44V20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 06:38:28 -0400 (EDT)
Date: Wed, 03 Sep 2014 07:38:23 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>
Subject: Re: [GIT PULL FINAL 16/21] m88ts2022: rename device state (priv => s)
Message-id: <20140903073823.54daad9b.m.chehab@samsung.com>
In-reply-to: <54067C6D.8090804@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
 <1408705093-5167-17-git-send-email-crope@iki.fi>
 <20140902155104.4b4e04dc.m.chehab@samsung.com> <54067C6D.8090804@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 03 Sep 2014 05:26:53 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 09/02/2014 09:51 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 22 Aug 2014 13:58:08 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> I like short names for things which are used everywhere overall the
> >> driver. Due to that rename device state pointer from 'priv' to 's'.
> >
> > Please, don't do that. "s" is generally used on several places for string.
> > If you want a shorter name, call it "st" for example.
> 
> huoh :/
> st is not even much better. 'dev' seems to be the 'official' term. I 
> will start using it. There is one caveat when 'dev' is used as kernel 
> dev_foo() logging requires pointer to device, which is also called dev.

Yeah, on v4l2, we generally use 'dev' for such struct on several drivers.
Yet, it looks confusing, especially when some part of the code needs to
work with the private structure and struct device.

So, we end having things like dev->udev->dev inside them, with looks
ugly, IMHO.

> for USB it is: intf->dev
> for PCI it is: pci->dev
> for I2C it is: client->dev
> 
> And you have to store that also your state in order to use logging (and 
> usually needed other things too). So for example I2C driver it goes:
> 
> struct driver_dev *dev = i2c_get_clientdata(client);
> dev_info(&dev->client->dev, "Hello World\n");
> 
> Maybe macro needed to shorten that dev_ logging, which takes as a first 
> parameter pointer to your own driver state.
> 
> I have used that 's' for many of my drivers already and there is likely 
> over 50 patches on my queue which needs to be rebased. And rebasing that 
> kind of thing for 50 patches is *really* painful, ugh.

No, it is as easy as running a one line command, as you can use git
filter-branch. I generally use it like:
	$ git filter-branch -f --msg-filter 'cat && sed s,foo,bar,g' patchwork..topic/r820t
To replace something at the comment (or to add a new comment), but I
used it already to automatically change some vars at replace.

You could also try to use the bfg[1].

Yet, one of problems of using 's' as a name is that seeking for it could
match something different. So, you'll likely need to use \bs\b as the
regex expression and likely review it.

[1] http://rtyley.github.io/bfg-repo-cleaner/

Another way of doing it is to export all patches to a directory
with:
	$ mkdir patches
	$ git format-patch -o patches some_base_branch..

then you can run a command to replace them like (untested):
	$ for i in `quilt series`; do sed -r 's,\bs\b,state,g' <$i >a && mv a $i; done

and then reapply on another branch with:

	$ git am --directory patches 

Btw, this revels another problem with names that are not unique
(like "dev") or too short, like "s": if later need to do some changes
or seek for all occurrences of such var, it could become a real pain.

Regards,
Mauro
