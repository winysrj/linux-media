Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42082
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750743AbdCAK0j (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 05:26:39 -0500
Date: Wed, 1 Mar 2017 07:00:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: bill murphy <gc2majortom@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Kaffeine commit b510bff2 won't compile
Message-ID: <20170301070024.3ca3150a@vento.lan>
In-Reply-To: <a2c23f62-215a-9066-45bc-0b8eebacc84b@gmail.com>
References: <bafdb165-261c-0129-e0dc-29819a55ca43@gmail.com>
        <20170227071122.3a319481@vento.lan>
        <a2c23f62-215a-9066-45bc-0b8eebacc84b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bill,

Em Mon, 27 Feb 2017 23:46:09 -0500
bill murphy <gc2majortom@gmail.com> escreveu:

> Hi Mauro,
> 
> Thanks for looking in to it. All is well now.

Good! Thanks for testing.

> On a sidenote, given 700 MHz is used for LTE, and not broadcasting
> 
> anymore, would you folks consider removing ch 52 thru 69
> 
> in the us-atsc-frequencies if I posted a simple patch to dtv-scan-tables?

The problem is that, despite its name, this table is used on other
Countries using atsc (like Mexico, Canada and South Korea):

	https://en.wikipedia.org/wiki/List_of_digital_television_deployments_by_country#/media/File:Digital_broadcast_standards.svg

So, while the 700 MHz are still used on other ATSC Countries, we can't
remove, as otherwise, it will not discover the channels at the upper
frequency range there.

Regards,
Mauro
