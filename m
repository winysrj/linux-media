Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:60338 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3FWVEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jun 2013 17:04:38 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so3940766bkc.30
        for <linux-media@vger.kernel.org>; Sun, 23 Jun 2013 14:04:36 -0700 (PDT)
Message-ID: <51C762E1.7010208@gmail.com>
Date: Sun, 23 Jun 2013 23:04:33 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, k.debski@samsung.com,
	jtp.park@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v2 7/8] [media] V4L: Add VP8 encoder controls
References: <1371560183-23244-1-git-send-email-arun.kk@samsung.com> <1371560183-23244-8-git-send-email-arun.kk@samsung.com> <51C76037.8050106@gmail.com>
In-Reply-To: <51C76037.8050106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2013 10:53 PM, Sylwester Nawrocki wrote:
>> @@ -558,7 +566,23 @@ EXPORT_SYMBOL(v4l2_ctrl_get_menu);
>> */
>> const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
>> {
[...]
> Then this would became:
>
> return __v4l2_qmenu_int_len(qmenu_int_vpx_num_partitions, &len);

erratum:

   return __v4l2_qmenu_int_len(qmenu_int_vpx_num_partitions, len);

:)
