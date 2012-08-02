Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44612 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891Ab2HBSNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 14:13:38 -0400
References: <50186040.1050908@lockie.ca> <c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com> <5019EE10.1000207@lockie.ca> <bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com> <CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com>
In-Reply-To: <CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 02 Aug 2012 14:13:45 -0400
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: James <bjlockie@lockie.ca>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Message-ID: <78067ada-2e91-40ff-bfd4-c22210861918@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

>On Thu, Aug 2, 2012 at 5:53 AM, Andy Walls <awalls@md.metrocast.net>
>wrote:
>> You can 'grep MODULE_ drivers/media/video/cx23885/*
>drivers/media/video/cx25840/* ' and other relevant directories under
>drivers/media/{dvb, common} to find all the parameter options for all
>the drivers involved in making a HVR_1250 work.
>
>Or just build with everything enabled until you know it is working,
>and then optimize the list of modules later.
>
>Also, the 1250 is broken for analog until very recently (patches went
>upstream for 3.5/3.6 a few days ago).
>
>Devin
>
>-- 
>Devin J. Heitmueller - Kernel Labs
>http://www.kernellabs.com

Oh, James meant kernel *build* options, not kernel *commandline/module* options.

Then what I offered won't help at all.

-Andy
