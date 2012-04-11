Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:34364 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929Ab2DKVdR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 17:33:17 -0400
Message-ID: <4F85F89A.80107@schinagl.nl>
Date: Wed, 11 Apr 2012 23:33:14 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com> <4F804CDC.3030306@gmail.com> <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com> <4F85D787.2050403@iki.fi>
In-Reply-To: <4F85D787.2050403@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/12 21:12, Antti Palosaari wrote:
> On 09.04.2012 15:02, Thomas Mair wrote:
>> thanks for your information. I did get in touch with Realtek and they
>> provided me with the datasheet for the RTL2832U. So what I will try to
>> do is write a demodulator driver for the RTL2832 demod chip following
>> the information of the datasheet and the Realtek driver. I will follow
>> Antti's RTL2830 driver structure.
>>
>> For now there is only one question left regarding the testing of the
>> drivers. What is the best way to test and debug the drivers. Sould I
>> compile the 3.4 kernel and use it, or is it safer to set up a
>> structure like the one I already have to test the driver with a stable
>> kernel?
>
> I vote for cloning Mauro's latest staging Kernel 3.5 and use it.
> http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.5
>
>
> I have some old stubbed drivers that just works for one frequency using
> combination of RTL2832U + FC2580. Also I have rather well commented USB
> sniff from that device. I can sent those if you wish.
>
FC2580? Do you have anything for/from that driver? My USB stick as an 
AFA9035 based one, using that specific tuner.

Oliver
