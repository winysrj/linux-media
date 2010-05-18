Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53690 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0ERMRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 08:17:10 -0400
Received: by fxm10 with SMTP id 10so1012012fxm.19
        for <linux-media@vger.kernel.org>; Tue, 18 May 2010 05:17:08 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: "Douglas Schilling Landgraf" <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: 2.6.29 additional build errors
References: <AANLkTilcusOnh6VdNR5Rvkd1wvSPLb2D7-EX5Ryy-LVz@mail.gmail.com>
 <AANLkTimKPmqQiIP32b8lc2EFFmqckcPBbvWYQV8--Oge@mail.gmail.com>
Date: Tue, 18 May 2010 14:17:01 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: =?iso-8859-2?B?U2FtdWVsIFJha2l0bmnoYW4=?=
	<samuel.rakitnican@gmail.com>
Message-ID: <op.vcwhqgudndeod6@crni>
In-Reply-To: <AANLkTimKPmqQiIP32b8lc2EFFmqckcPBbvWYQV8--Oge@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 May 2010 07:03:51 +0200, Douglas Schilling Landgraf  
<dougsland@gmail.com> wrote:

> Hello Samuel,
>
> 2010/5/15 Samuel Rakitnièan <samuel.rakitnican@gmail.com>:
>> Additional build errors found after disabling the non building modules
>> on todays mercurial tree.
>
> Please update your local repository:
>
> $ hg pull -u
> $ make distclean
> $ make
>
> Now should work.
>

Yes, it builds fine now. Thank you for fixing this.


Regards,
Samuel
