Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29662 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2ITIeL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 04:34:11 -0400
Received: from eusync3.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAN00HBC3TWYP90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Sep 2012 09:34:44 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAN00KR23SXO040@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Sep 2012 09:34:09 +0100 (BST)
Message-id: <505AD500.3040408@samsung.com>
Date: Thu, 20 Sep 2012 10:34:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Richard Zhao <richard.zhao@freescale.com>
Cc: javier Martin <javier.martin@vista-silicon.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
Subject: Re: [GIT PULL v2] Initial i.MX5/CODA7 support for the CODA driver
References: <1347957978.2529.4.camel@pizza.hi.pengutronix.de>
 <20120920033206.GA9407@b20223-02.ap.freescale.net>
 <CACKLOr0BATxZc3xwE44JJowTcOf1N4XT1oXGW9Gj0n0s-wSd_w@mail.gmail.com>
 <20120920080358.GB9407@b20223-02.ap.freescale.net>
In-reply-to: <20120920080358.GB9407@b20223-02.ap.freescale.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2012 10:03 AM, Richard Zhao wrote:
> On Thu, Sep 20, 2012 at 09:10:46AM +0200, javier Martin wrote:
>> Hi Richard,
>>
>> On 20 September 2012 05:32, Richard Zhao <richard.zhao@freescale.com> wrote:
>>> why is it a request-pull?
>>
>> After 5 version of Philipp's patches we have agreed they are good
>> enough to be merged; they don't break anything related to the old
>> codadx6 while provide support for the new coda7:
>> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/53627
>>
>> The pull request is a way to tell Mauro this is ready to be merged in
>> his linux-media tree and making things easier for him.
> I know the meaning. I just feel strange. Pull request is normally sent
> by maintainer to up level maintainer who agreed to receive pull request.

There is really high volume of various kind of patches on linux-media
mailing lists. Even with those pull requests it becomes hard for Mauro
to respond and merge patches in timely manner. There is even a discussion 
related to this scheduled for media workshop during ELCE/LinuxCon. I think 
the rules may differ slightly across kernel subsystems, hence I find nothing 
unusual in using pull requests, especially by sub-subsystem maintainers or
developers.

Regards,
Sylwester
