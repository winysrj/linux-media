Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:34990 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754656AbeD3O6a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 10:58:30 -0400
Subject: Re: [RFCv11 PATCH 26/29] vim2m: use workqueue
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-27-hverkuil@xs4all.nl>
 <CAAFQd5CjKys=gPetj8fJE8=rVDjMh4bQdT1Pf+NHfBWCmj+rjQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <afc9b766-d8a2-6b5c-6727-679d28993d93@xs4all.nl>
Date: Mon, 30 Apr 2018 16:58:28 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5CjKys=gPetj8fJE8=rVDjMh4bQdT1Pf+NHfBWCmj+rjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/04/18 11:02, Tomasz Figa wrote:
> Hi Hans,
> 
> On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> v4l2_ctrl uses mutexes, so we can't setup a ctrl_handler in
>> interrupt context. Switch to a workqueue instead.
> 
> Could it make more sense to just replace the old (non-hr) timer used in
> this driver with delayed work?

I agree. I'll change that once v12 is posted to the mailing list.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 
