Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52157 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751936AbdIRH0e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 03:26:34 -0400
Message-ID: <1505719582.25945.271.camel@linux.intel.com>
Subject: Re: [PATCH] staging: atomisp: add a driver for ov5648 camera sensor
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Devid Antonio Filoni <d.filoni@ubuntu.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        =?ISO-8859-1?Q?J=E9r=E9my?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 18 Sep 2017 10:26:22 +0300
In-Reply-To: <20170911180303.GA14304@dfiloni-N82JQ>
References: <1505046221-14358-1-git-send-email-d.filoni@ubuntu.com>
         <20170911145529.xelwo2ip67k4jfwb@valkosipuli.retiisi.org.uk>
         <20170911180303.GA14304@dfiloni-N82JQ>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-09-11 at 20:03 +0200, Devid Antonio Filoni wrote:
> On Mon, Sep 11, 2017 at 05:55:29PM +0300, Sakari Ailus wrote:
> > Hi Devid,
> > 
> > Please see my comments below.
> > 
> > Andy: please look for "INT5648".
> 
> Hi Sakari,
> I'm replying below to your comments. I'll work on a v2 patch as soon
> as we get
> more comments.
> 
> About "INT5648", I extracted it from the DSDT of my Lenovo Miix 310,
> take a look
> at https://pastebin.com/ExHWYr8g .

First of all, thank you, Sakari, to raise a flag here.

Second, Devid, please answer to the following:
is it an official BIOS which is available in the wild?

If it's so, please, add a paragraph to the commit message explaining how do you get this and point to the DSDT excerpt.
Put an answer to above question to the commit message as well.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
