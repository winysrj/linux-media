Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:39114 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752863AbdFQLOj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 07:14:39 -0400
Date: Sat, 17 Jun 2017 13:14:36 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 03/16] lirc_dev: correct error handling
Message-ID: <20170617111436.4zlmumsfw4zz5y3f@hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
 <149365463117.12922.15518669536847504845.stgit@zeus.hardeman.nu>
 <20170521085712.GA29355@gofer.mess.org>
 <20170528082337.2hk4zwfi47xzjqea@hardeman.nu>
 <20170528150429.GA18977@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170528150429.GA18977@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 28, 2017 at 04:04:30PM +0100, Sean Young wrote:
>On Sun, May 28, 2017 at 10:23:37AM +0200, David Härdeman wrote:
>> On Sun, May 21, 2017 at 09:57:13AM +0100, Sean Young wrote:
>> >On Mon, May 01, 2017 at 06:03:51PM +0200, David Härdeman wrote:
>> >> If an error is generated, nonseekable_open() shouldn't be called.
>> >
>> >There is no harm in calling nonseekable_open(), so this commit is
>> >misleading.
>> 
>> I'm not sure why you consider it misleading? If there's an error, the
>> logic thing to do is to error out immediately and not do any further
>> work?
>
>The commit message says that nonseekable_open() should not be called,
>suggesting there is a bug which is not the case.

I'll do another version with an updated commit message then :)

-- 
David Härdeman
