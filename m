Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:48519 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab0FYM05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jun 2010 08:26:57 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Pascal Hahn <derpassi@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: CI-Module not working on Technisat Cablestar HD2
References: <AANLkTinz5Wvd7XuFIxsMMOV2XUTEXAafRUgXiBMLpEQn@mail.gmail.com>
	<87r5jw4nmg.fsf@nemi.mork.no>
	<AANLkTinY4jzSBe5mp0MskB-bLNTtc54L29ApgxtGskOK@mail.gmail.com>
Date: Fri, 25 Jun 2010 14:26:51 +0200
In-Reply-To: <AANLkTinY4jzSBe5mp0MskB-bLNTtc54L29ApgxtGskOK@mail.gmail.com>
	(Pascal Hahn's message of "Fri, 25 Jun 2010 14:15:35 +0200")
Message-ID: <871vbvuwl0.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pascal Hahn <derpassi@gmail.com> writes:

> Thanks for the feedback already. Do you know which kernel version this
> driver is functional in out of the top of your head?
>
> I tried multiple kernels and had no luck getting it to work so far.

If you are talking about the mantis driver in Linus' mainline kernels,
then it isn't updated at all since it was merged.  No need to try
different kernels. They are all the same with respect to this driver.

But the mantis driver went through a lot of changes during the very
active development before it was merged, and the CA code used to be
enabled at some point.  But I do not know if it worked.  And there were
most likely very good reasons to disable it...

Google will know.


Bjørn
