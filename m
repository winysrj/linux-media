Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36209 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbbDAXzx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 19:55:53 -0400
Date: Thu, 2 Apr 2015 01:55:20 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Send and receive decoded IR using lirc interface
Message-ID: <20150401235520.GA4642@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
 <20150330211819.GA18426@hardeman.nu>
 <20150331204716.6795177d@concha.lan>
 <20150401221941.GC4721@hardeman.nu>
 <20150401201016.616fca34@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150401201016.616fca34@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 01, 2015 at 08:10:16PM -0300, Mauro Carvalho Chehab wrote:
>Em Thu, 02 Apr 2015 00:19:41 +0200
>David Härdeman <david@hardeman.nu> escreveu:
>
>> On Tue, Mar 31, 2015 at 08:47:16PM -0300, Mauro Carvalho Chehab wrote:
>> >Em Mon, 30 Mar 2015 23:18:19 +0200
>> >David Härdeman <david@hardeman.nu> escreveu:
>> >> On Thu, Mar 19, 2015 at 09:50:11PM +0000, Sean Young wrote:
>> >> Second, if we expose protocol type (which we should, not doing so is
>> >> throwing away valuable information) we should tackle the NEC scancode
>> >> question. I've already explained my firm conviction that always
>> >> reporting NEC as a 32 bit scancode is the only sane thing to do. Mauro
>> >> is of the opinion that NEC16/24/32 should be essentially different
>> >> protocols.
>> >
>> >Changing NEC would break userspace, as existing tables won't work.
>> >So, no matter what I think, changing it won't happen as we're not
>> >allowed to break userspace.
>> 
>> I have no idea what breakage you're talking about. Sean's patches would
>> introduce new API, so they can't break anything. 
>
>Sure, but changing RX would break, and using 32 bits just for TX,
>while keeping 16/24/32 for RX would be too messy.

Sorry, I still don't follow...why and how would RX break?

-- 
David Härdeman
