Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37770 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2HTKng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 06:43:36 -0400
Received: by qcro28 with SMTP id o28so4265720qcr.19
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 03:43:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADPsn1YyOO=wS5eh3H0MJTgwga=j49eE+rn=xcVUaq+ES7CK+A@mail.gmail.com>
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org>
	<501ADEF6.1080901@gmail.com>
	<CADPsn1b6TxhmWVzzH1u-wr0UZs6D3cif4+r1S9OOROx1iXCXUQ@mail.gmail.com>
	<50315AC8.5060100@gmail.com>
	<CADPsn1YyOO=wS5eh3H0MJTgwga=j49eE+rn=xcVUaq+ES7CK+A@mail.gmail.com>
Date: Mon, 20 Aug 2012 11:43:35 +0100
Message-ID: <CADPsn1ZnqxRYd2kTWcOatZVgdcWWbNCA9kwMaWs4O_tk2gYEPQ@mail.gmail.com>
Subject: Re: [PATH v3 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with
 embedded SoC ISP
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On 20 August 2012 09:12, Sangwook Lee <sangwook.lee@linaro.org> wrote:
> Hi Sylwester
>
> On 19 August 2012 22:29, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com> wrote:
>> Hi Sangwook,
>>
>> On 08/03/2012 04:24 PM, Sangwook Lee wrote:
>>> I was thinking about this, but this seems to be is a bit time-consuming because
>>> I have to do this just due to lack of s5k4ecgx hardware information.
>>> let me try it later once
>>> this patch is accepted.
>>
>> I've converted this driver to use function calls instead of the register
>> arrays. It can be pulled, along with a couple of minor fixes/improvements,
>> from following git tree:
>>
>>         git://linuxtv.org/snawrocki/media.git s5k4ecgx
>>         (gitweb: http://git.linuxtv.org/snawrocki/media.git/s5k4ecgx)
>>
>> I don't own any Origen board thus it's untested. Could you give it a try ?

Sorry, It doesn't work. I will send pictures to you by another mail thread.
Previously, I tested preview array and found out that
+	/*
+	 * FIXME: according to the datasheet,
+	 * 0x70000496~ 0x7000049c seems to be only for capture mode,
+	 * but without these value, it doesn't work with preview mode.
+	 */

Do we need to set those values ?


Thanks
Sangwook


>
> Wow! Great,  let me download from this git and then test.
>


Thanks



>
