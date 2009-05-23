Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:65326 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZEWGls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 02:41:48 -0400
Received: by bwz22 with SMTP id 22so2012874bwz.37
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 23:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905230810.39344.jarhuba2@poczta.onet.pl>
References: <200905230810.39344.jarhuba2@poczta.onet.pl>
Date: Sat, 23 May 2009 10:41:48 +0400
Message-ID: <1a297b360905222341t4e66e2c6x95d339838db43139@mail.gmail.com>
Subject: Re: Question about driver for Mantis
From: Manu Abraham <abraham.manu@gmail.com>
To: jarhuba2@poczta.onet.pl
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 23, 2009 at 10:10 AM, Jaros³aw Huba <jarhuba2@poczta.onet.pl> wrote:
> Hi.
> Is driver for Mantis chipset are currently developed somewhere?
> I'm owner of Azurewave AD SP400 CI (VP-1041) and I'm waiting for support for
> this card for quite long time. Even partly working driver in mainline kernel
> would be great (without remote, CI, S2 support, with some tuning bugs).
> This question is mainly for Manu Abraham who developed this driver some time
> ago.

The latest development snapshot for the mantis based devices can be found
here: http://jusst.de/hg/mantis-v4l

Currently CI is unsupported, though very preliminary code support for
it exists in it.
S2 works, pretty much. Or do you have other results ?

Regards,
Manu
