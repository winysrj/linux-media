Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52539 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753349AbeAQNxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 08:53:05 -0500
Message-ID: <1516197156.4184.2.camel@linux.intel.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
From: Alan Cox <alan@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Kristian Beilke <beilke@posteo.de>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Date: Wed, 17 Jan 2018 13:52:36 +0000
In-Reply-To: <1515088333.7000.708.camel@linux.intel.com>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
         <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
         <1513715821.7000.228.camel@linux.intel.com>
         <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
         <1513866211.7000.250.camel@linux.intel.com>
         <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
         <1514476996.7000.437.camel@linux.intel.com>
         <20171230211025.7aeaafcd@alans-desktop>
         <1515088333.7000.708.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Maybe we need start over, i.e. find a (presumable old) kernel with
> driver _and_ corresponding firmware _and_ hardware it supports to
> start
> with...

You can do that with Intel aero and then in theory port the relevant
headers into the updated driver. I've actually been closely comparing
them to see what ships but for the past few months I got dragged off it
for the most part onto the security work.

Alan
