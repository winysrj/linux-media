Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:51366 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbbETJSL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 05:18:11 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [RFC PATCH 6/6] [media] rc: teach lirc how to send scancodes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 20 May 2015 11:18:09 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
In-Reply-To: <20150520060853.5d3a5e0d@recife.lan>
References: <cover.1426801061.git.sean@mess.org>
 <985a9b11e5e02eb43e16d27db23086528434be24.1426801061.git.sean@mess.org>
 <d83477bae9a733323fd072def6384a3b@hardeman.nu>
 <20150520060853.5d3a5e0d@recife.lan>
Message-ID: <cd8f8ae67e82660173b0d291f394d810@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-05-20 11:08, Mauro Carvalho Chehab wrote:
> Em Wed, 20 May 2015 10:53:59 +0200
> David Härdeman <david@hardeman.nu> escreveu:
> 
>> On 2015-03-19 22:50, Sean Young wrote:
>> > The send mode has to be switched to LIRC_MODE_SCANCODE and then you can
>> > send one scancode with a write. The encoding is the same as for
>> > receiving
>> > scancodes.
>> 
>> Why do the encoding in-kernel when it can be done in userspace?
>> 
>> I'd understand if it was hardware that accepted a scancode as input, 
>> but
>> that doesn't seem to be the case?
> 
> IMO, that makes the interface clearer. Also, the encoding code is 
> needed
> anyway, as it is needed to setup the wake up keycode on some hardware.
> So, we already added encoder capabilities at some decoders:

I know.

But with the proposed API userspace would have to first try to send a 
scancode + protocol, then see what the error code was, and if it 
indicated that the kernel couldn't encode the scancode, userspace would 
anyway have to encode it itself and then try again with raw events?

I think that's a bad API (to put it mildly).

There's simply no need to encode the scancodes in kernel (even if the 
code happens to be present for a random and fluctuating set of 
protocols) and any well-written userspace would have to include code to 
encode to any protocol it wants to support (since it can't rely on the 
kernel supporting any given protocol)....what does that buy you except a 
hairy API and added complexity?

