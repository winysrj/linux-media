Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36611 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbdCCSX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 13:23:56 -0500
MIME-Version: 1.0
In-Reply-To: <20170303174552.GP3220@valkosipuli.retiisi.org.uk>
References: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com> <20170303174552.GP3220@valkosipuli.retiisi.org.uk>
From: SIMRAN SINGHAL <singhalsimran0@gmail.com>
Date: Fri, 3 Mar 2017 23:53:53 +0530
Message-ID: <CALrZqyOeOK2k1K8Z2Yt3SmvJQ8A+vigNBsd39-paPwkRAY6CVQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] staging: media: Remove unnecessary typecast of c90
 int constant
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 3, 2017 at 11:15 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Simran,
>
> On Fri, Mar 03, 2017 at 01:21:56AM +0530, simran singhal wrote:
>> This patch removes unnecessary typecast of c90 int constant.
>>
>> WARNING: Unnecessary typecast of c90 int constant
>>
>> Signed-off-by: simran singhal <singhalsimran0@gmail.com>
>
> Which tree are these patches based on?
Can you please explain what's the problem with this patch. And
please elaborate your question.

>
> --
> Regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
