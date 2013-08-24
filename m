Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36385 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3HXQjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 12:39:35 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so1332858lbh.9
        for <linux-media@vger.kernel.org>; Sat, 24 Aug 2013 09:39:34 -0700 (PDT)
Message-ID: <5218E1CE.8050600@cogentembedded.com>
Date: Sat, 24 Aug 2013 20:39:42 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: m.chehab@samsung.com
CC: Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux@arm.linux.org.uk,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v5 0/3] R8A7779/Marzen R-Car VIN driver support
References: <201308230119.13783.sergei.shtylyov@cogentembedded.com> <20130823001140.GD9254@verge.net.au>
In-Reply-To: <20130823001140.GD9254@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 08/23/2013 04:11 AM, Simon Horman wrote:

>>     [Resending with a real version #.]

>>     Here's the set of 3 patches against the Mauro's 'media_tree.git' repo's
>> 'master' branch. Here we add the VIN driver platform code for the R8A7779/Marzen
>> with ADV7180 I2C video decoder.

>> [1/3] ARM: shmobile: r8a7779: add VIN support
>> [2/3] ARM: shmobile: Marzen: add VIN and ADV7180 support
>> [3/3] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig

>>      Mauro has kindly agreed to merge this patchset thru his tree to resolve the
>> dependency on the driver's platform data header, provided that the maintainer
>> ACKs this. Simon, could you ACK the patchset ASAP -- Mauro expects to close his
>> tree for 3.12 this weekend or next Monday?

> All three patches:

> Acked-by: Simon Horman <horms+renesas@verge.net.au>

    Mauro, I see you have only merged the R8A7778/BOCK-W VIN series and didn't 
merge this one, obsoleting its patches in patchwork instead. What's wrong with 
them?

WBR, Sergei

