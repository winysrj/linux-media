Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE56AC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 16:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B900820828
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 16:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfCYQ1n (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:27:43 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57647 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbfCYQ1n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 12:27:43 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 8SRlhhOinNG8z8SRphQUsO; Mon, 25 Mar 2019 17:27:41 +0100
Subject: Re: CEC blocks idle on omap4
To:     Tony Lindgren <tony@atomide.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org
References: <20190325153258.GU5717@atomide.com>
 <dc7e900c-52e2-3268-6c08-6a5b0049135a@xs4all.nl>
 <20190325155532.GB8280@pendragon.ideasonboard.com>
 <d3619d3b-1051-9b05-a0a9-ebc9b69241ce@xs4all.nl>
 <20190325162115.GM19425@atomide.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ce79cce0-bbd7-95e3-2035-c99be6c94cb4@xs4all.nl>
Date:   Mon, 25 Mar 2019 17:27:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190325162115.GM19425@atomide.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOKsn1Q8OKjE+Vsk3URwnKs+zvOSpTeWS4T8qZ94KTZ4+XbD8gnELMYmqO+aXNWiQAkoYx4eD1HKGoOFuZBQw2efd8JbTIaEq+HsXszHIP0SqUmMotsB
 TBC48yR9+gQ3vtI0NGL39LaqYZMdOzmzPGu1ev+lWhbaWoSrrlxJZc4rNJyWNO8E8fTxWkxBW82ILkUUdRQFZY8jwyimlnYvGuft5zpGYnoKY3vFoLOSCQxk
 x9AR9Gu9uGgk+vj4l2vxZSif2UJyn3JpuGccV774Qlr6hz7vapbQNvkwC9XBFUUb9QEaGZEdEP6/vO7hUyusFvtsUy8jB++Gr2jWiPJ4OBXcVg6T9EGiXPVP
 BzJmcPX0ov5/xwK7tEwtSrIn3zwX1w==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/25/19 5:21 PM, Tony Lindgren wrote:
> * Hans Verkuil <hverkuil@xs4all.nl> [190325 16:12]:
>> On 3/25/19 4:55 PM, Laurent Pinchart wrote:
>>>> The reality is that HDMI CEC and HDMI video are really independent of
>>>> one another. So I wonder if it isn't better to explain the downsides
>>>> of enabling CEC for the omap4 in the CONFIG_OMAP4_DSS_HDMI_CEC
>>>> description. And perhaps disable it by default?
>>>
>>> This should be controllable by userspace. From a product point of view,
>>> it should be possible to put the system in a deep sleep state where CEC
>>> isn't available, or in a low sleep state where CEC works as expected.
>>>
>>
>> Userspace can always disable CEC. The hdmi_cec_adap_enable() callback in
>> hdmi4_cec.c is called whenever the CEC adapter is enabled or disabled.
> 
> OK
> 
>> I'm not actually sure why hdmi4_cec_init() would block anything since it
>> just registers the CEC device. It does not enable it until userspace
>> explicitly enables it with e.g. 'cec-ctl --playback'.
>>
>> hdmi4_cec_init() does configure a CEC clock, but that can be moved to
>> hdmi_cec_adap_enable() if necessary.
> 
> Hey I'm pretty sure that's the right fix then :)
> 
>> Note that I am not sure what is meant with 'SoC core retention idle',
>> so perhaps I just misunderstand the problem.
> 
> If certain SoC clocks are busy, the SoC will not enter deeper
> idle states. The hardware has autoidle type features on omaps.

Can you make a patch? It is very easy to test:

To configure the CEC adapter: cec-ctl --playback
To unconfigure the CEC adapter: cec-ctl --clear

As long as the CEC adapter is unconfigured you should be able to enter
the deeper idle states. But not if it is configured.

And if you are moving code anyway, can you fix the typo in the comment?
devider -> divider

That hurts my eyes...

Regards,

	Hans
