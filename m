Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:53618 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3FYEdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 00:33:50 -0400
Received: by mail-ve0-f177.google.com with SMTP id cz10so9480688veb.22
        for <linux-media@vger.kernel.org>; Mon, 24 Jun 2013 21:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51C75FA4.2010303@gmail.com>
References: <1371560183-23244-1-git-send-email-arun.kk@samsung.com>
	<1371560183-23244-7-git-send-email-arun.kk@samsung.com>
	<51C75FA4.2010303@gmail.com>
Date: Tue, 25 Jun 2013 10:03:49 +0530
Message-ID: <CALt3h7_LA-mUr_LtXtGeSqc_mVudtNA05-iL3xNho=zu1ibGjw@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] [media] V4L: Add support for integer menu controls
 with standard menu items
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, Jun 24, 2013 at 2:20 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Arun,
>
>
> On 06/18/2013 02:56 PM, Arun Kumar K wrote:
>>
>> @@ -806,6 +820,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>         case V4L2_CID_FM_RX_CLASS:              return "FM Radio Receiver
>> Controls";
>>         case V4L2_CID_TUNE_DEEMPHASIS:          return "De-Emphasis";
>>         case V4L2_CID_RDS_RECEPTION:            return "RDS Reception";
>> +
>>         default:
>>                 return NULL;
>>         }
>
>
> This change would need to be moved to patch 7/8.
>

Yes. Even better I will discard this change.

Regards
Arun
