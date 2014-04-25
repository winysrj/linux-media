Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:46787 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbaDYN04 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 09:26:56 -0400
Date: Fri, 25 Apr 2014 10:26:25 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Steve Cookson <it@sca-uk.com>
Cc: Steve Cookson <steve.cookson@sca-uk.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Comparisons of images between Dazzle DVC100, EasyCap stk1160 and
 Hauppauge ImapctVCB-e in Linux.
Message-ID: <20140425132625.GA1364@arch.cereza>
References: <5357DAC2.20005@sca-uk.com>
 <535A52CB.7060106@sca-uk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535A52CB.7060106@sca-uk.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 25, Steve Cookson wrote:
[..]
> 
> If the DVC100 and ImpactVCB-e had had the same love and attention that
> Ezequial has shown the EasyCap would they outperform it?
> 

I really appreciate the kind words and I'm happy to see the driver is being
used and works well.

However, to be fair, the stk1160 is just a little link in a larger chain.
The video decoder is controlled through another driver (saa7115) and so
I've little merit in the image quality.

[..]
> 
> Otherwise I should just focus on EasyCap for my raw SD capture and move on.
> 

Hm.. hard to say. Easycap stk1160 devices are hard to get, it seems they are
manufactured in a few different hardware flavors (but with the same case)
and it's hard to tell what flavor you buy.

Right now, I think we've supported the two stk1160 cases, but there's a
third Easycap variant currently unsupported (which doesn't use stk1160
but a Somagic chipset).

In addition, given the stk1160 was partly reverse-engineered, partly
based on a non-public and very laconic datasheet, it's not easy to fix
given the lack of details about the chip.

In conclusion, if you pick stk1160, make sure you buy enough Easycap devices
(from the same provider) and do some extra effort to test *each* of them to
ensure they work as you expect.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
