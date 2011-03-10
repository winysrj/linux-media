Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40202 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1CJGqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 01:46:01 -0500
Received: by iwn34 with SMTP id 34so1237507iwn.19
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2011 22:46:01 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Mar 2011 22:46:01 -0800
Message-ID: <AANLkTinR+orbk5iMbRmFvVFfkPYbn5CJUbGw7jrONS2w@mail.gmail.com>
Subject: Question on OpenCV camera support
From: Ignacio Hernandez <ignacio.hernandez@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm seeing that when using OpenCV there is no way to query video
camera capabilities from within the API, you need to go straight into
V4L stuff to get that info.  I did a patch for enabling such
capabilities but I'm looking into the appropriate forum for submitting
the code, does anyone here can point me to the right forum/persons to
achieve that?

Thanks,
Ignacio
