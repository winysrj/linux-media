Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:56842 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZHEPWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 11:22:17 -0400
Received: by ewy10 with SMTP id 10so61592ewy.37
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 08:22:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15ed362e0908050714y61696f9gf794a907e85ed801@mail.gmail.com>
References: <15ed362e0908050714y61696f9gf794a907e85ed801@mail.gmail.com>
Date: Wed, 5 Aug 2009 11:22:16 -0400
Message-ID: <37219a840908050822i44f1b432y4fa91e2a8e49d349@mail.gmail.com>
Subject: Re: lgs8gxx: 64bit division
From: Michael Krufky <mkrufky@kernellabs.com>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 10:14 AM, David Wong<davidtlwong@gmail.com> wrote:
> Dear all,
>
>  Someone complains that he cannot compile my lgs8gxx.c on gcc3,
> unknown kernel version.  Compilation
> error at line 249 about the 64-bit division. I have no compilation
> error on my x86_64 system, gcc4,
> linux-2.6.28 kernel. Should the 64-bit division code be changed?
>
>  There is also it 64bit / 32bit division via do_div(), is it correct?

David,

The following changeset illustrates how to use do_div to handle 64bit
division regardless of 32 / 64 bit architecture.

http://linuxtv.org/hg/v4l-dvb/rev/530c2f70dc25

I hope this helps.

Regards,

Mike
