Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38507 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab2EFRAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 13:00:55 -0400
Received: by bkcji2 with SMTP id ji2so3160476bkc.19
        for <linux-media@vger.kernel.org>; Sun, 06 May 2012 10:00:54 -0700 (PDT)
Message-ID: <4FA6AE43.3080907@gmail.com>
Date: Sun, 06 May 2012 19:00:51 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v4 01/12] V4L: Add helper function for standard integer
 menu controls
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com> <1336156337-10935-2-git-send-email-s.nawrocki@samsung.com> <4FA64EAB.20600@iki.fi>
In-Reply-To: <4FA64EAB.20600@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 05/06/2012 12:12 PM, Sakari Ailus wrote:
> Hi Sylwester,
>
> Sylwester Nawrocki wrote:
>> This patch adds v4l2_ctrl_new_std_int_menu() helper function which can
>> be used in drivers for creating standard integer menu control. It is
>> similar to v4l2_ctrl_new_std_menu(), except it doesn't have a mask
>> parameter and an additional qmenu parameter allows passing an array
>> of signed 64-bit integers constituting the menu items.
>
> It would make sense to have the mask and no pointer to the menu items if
> the menu items are universally the same. This could come into question
> on some standards, for example. For example, we currently have bit rates
> in controls but they are strings, not integers. I could imagine we will
> have such menus in the future.
>
> I'd suggest to rename v4l2_ctrl_new_std_int_menu() as
> v4l2_ctrl_new_int_menu(), as opposed to the former which would use
> standardised items in the menu --- to be implemented when needed.

Thank you for pointing it out. Let me just correct this and resend
the patch.

Best regards,
Sylwester
