Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878A6C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EAC5214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfAJMFW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 07:05:22 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:32873 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728088AbfAJMFV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 07:05:21 -0500
Received: from [IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f] ([IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f])
        by smtp-cloud9.xs4all.net with ESMTPA
        id hZ5HgauAcMWvEhZ5LgX5CC; Thu, 10 Jan 2019 13:05:19 +0100
Subject: Re: [RFC PATCH 5/5] v4l2-ctl: add an option to list controls in a
 machine-readable format
To:     Antonio Ospite <ao2@ao2.it>
Cc:     linux-media@vger.kernel.org
References: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
 <20190103180102.12282-1-ao2@ao2.it> <20190103180102.12282-6-ao2@ao2.it>
 <3f081956-7733-069b-da24-0d04831b8ed1@xs4all.nl>
 <20190109221508.eaa19c66df252a1f9802cd9a@ao2.it>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c0242c60-849e-b393-0e67-ca54d6d2e18d@xs4all.nl>
Date:   Thu, 10 Jan 2019 13:05:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190109221508.eaa19c66df252a1f9802cd9a@ao2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfN1ktg597voEbVSbQZpE3d4oJLqMEtKdl1dKKpLbTVOK+FeesSvyzFExyzggZQvEHv1+DNT2qe1NVdGSv8gTPoN+oIyB8d7m8vgsLY6cDRT2UesZxun/
 k+cqF3J2z6fHRVrAjHQPv/0Oq+DsnAuH0Efu6eLTBtjwOnCOjTnLCK1FmbMuMEmaRdFFEnO4A63tvitgCQIdCaZsDMpTyKtadV6URSoIkkhF4w0iLZ1OOsd6
 nro0J0Zex7SIaU27rbXkO9L9O3Th9nQh/P/NdthQTYZPFJ908md0gTfszLVHQ1veWTjBNuQl8L9AR9V2Q1tPnA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/09/19 22:15, Antonio Ospite wrote:
> On Mon, 7 Jan 2019 11:18:58 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> On 01/03/2019 07:01 PM, Antonio Ospite wrote:
>>> Add a new option --list-ctrls-values to list the values of controls in
>>> a format which can be passed again to --set-ctrl.
>>>
>>> This can be useful to save and restore device settings:
>>>
>>>   $ v4l2-ctl --list-ctrls-values >settings.txt 2>/dev/null
>>>   $ v4l2-ctl --set-ctrl "$(cat settings.txt)"
>>>
>>> The new option has been tested with the vivid driver and it works well
>>> enough to be useful with a real driver as well.
>>>
>>> String controls are not supported for now, as they may not be parsed
>>> correctly by --set-ctrl if they contain a comma or a single quote.
>>>
>>> Signed-off-by: Antonio Ospite <ao2@ao2.it>
>>> ---
>>>  utils/v4l2-ctl/v4l2-ctl-common.cpp | 72 ++++++++++++++++++++++++++----
>>>  utils/v4l2-ctl/v4l2-ctl.1.in       |  4 ++
>>>  utils/v4l2-ctl/v4l2-ctl.cpp        |  1 +
>>>  utils/v4l2-ctl/v4l2-ctl.h          |  1 +
>>>  4 files changed, 69 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
>>> index 7777b45c..b4124608 100644
>>> --- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
>>> +++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> [...]
>>> @@ -1102,13 +1146,23 @@ void common_get(cv4l_fd &_fd)
>>>  
>>>  void common_list(cv4l_fd &fd)
>>>  {
>>> -	if (options[OptListCtrls] || options[OptListCtrlsMenus]) {
>>> -		struct print_format classic_format = {
>>> -			.print_class_name = print_class_name,
>>> -			.print_qctrl = print_qctrl,
>>> -			.show_menus = options[OptListCtrlsMenus],
>>> -		};
>>> -
>>> -		list_controls(fd.g_fd(), &classic_format);
>>> +	if (options[OptListCtrls] || options[OptListCtrlsMenus] || options[OptListCtrlsValues]) {
>>> +		if (options[OptListCtrlsValues]) {
>>> +			struct print_format machine_format = {
>>> +				.print_class_name = NULL,
>>> +				.print_qctrl = print_qctrl_values,
>>> +				.show_menus = 0,
>>> +			};
>>> +
>>> +			list_controls(fd.g_fd(), &machine_format);
>>> +		} else {
>>> +			struct print_format classic_format = {
>>> +				.print_class_name = print_class_name,
>>> +				.print_qctrl = print_qctrl,
>>> +				.show_menus = options[OptListCtrlsMenus],
>>> +			};
>>> +
>>> +			list_controls(fd.g_fd(), &classic_format);
>>> +		}
>>
>> I don't like this struct print_format.
>>
> 
> Hi Hans,
> 
> the idea was based on two considerations:
>   1. decide the format once and for all, avoiding to check each time a
>      control is printed.
>   2. have at least some partial infrastructure in case some
>      other export formats were to be added.
> 
> But yeah, as 2. seems quite unlikely I can go with a more essential
> approach for now, no problem.
> 
>> I would prefer something like this:
>>
>> Rename print_qctrl to print_qctrl_readable() and create a new print_qctrl:
>>
>> static void print_qctrl(int fd, struct v4l2_query_ext_ctrl *queryctrl,
>>                 struct v4l2_ext_control *ctrl, int show_menus)
>> {
>> 	if (options[OptListCtrlsValues])
>> 		print_qctrl_values(fd, queryctrl, ctrl, show_menus);
>> 	else
>> 		print_qctrl_readable(fd, queryctrl, ctrl, show_menus);
>> }
>>
> 
> Since "readable" here means "human readable", while "values" is meant
> for a "machine readable" output, I'd "avoid" the word "readable" at
> all and go with "details" or "description":
> 
> 	if (options[OptListCtrlsValues])
> 		print_qctrl_values(fd, queryctrl, ctrl, show_menus);
> 	else
> 		print_qctrl_details(fd, queryctrl, ctrl, show_menus);

Hmm. Perhaps we should just be explicit:

	print_qctrl_machine_readable
	print_qctrl_human_readable

I think that's best.

> 
>> And in print_control you can just skip printing the class name if
>> options[OptListCtrlsValues] is set.
>>
> 
> OK.
> 
>> I would like to see string controls being supported. I would recommend
>> to just write the string as a hexdump. It avoids having to escape characters.
>>
>> The same can be done for compound/array controls. In fact, you could write
>> all controls that way. It would simplify things a lot.
>>
> 
> But then --set-ctrl would need to be extended to parse the hexdump,
> wouldn't it? Do you already have a syntax in mind?

I would add a new --set-ctrl-value option that takes a hexdump.
Basically the inverse of --list-ctrls-values.

Regards,

	Hans

> 
> TBH, I kept things simple hoping to re-use --set-ctrl without too much
> work.
> 
>> Also, when options[OptListCtrlsValues] is set you should skip all WRITE_ONLY
>> controls, all BUTTON controls, and all volatile controls. They are not
>> relevant if you are just interested in controls that can be set.
>>
> 
> That I will do in any case, thank you.
> 
>> Regards,
>>
>> 	Hans
> 
> Thank you,
>    Antonio
> 

