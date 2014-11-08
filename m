Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34329 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbaKHCVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Nov 2014 21:21:42 -0500
Received: by mail-ob0-f180.google.com with SMTP id wp4so3469244obc.39
        for <linux-media@vger.kernel.org>; Fri, 07 Nov 2014 18:21:42 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 8 Nov 2014 10:21:42 +0800
Message-ID: <CANC6fRFjG6002rDiJjfDHteQSAnRkwfpyWV8wB39oHu5P8Q2mA@mail.gmail.com>
Subject: Add controls to query camera read only paramters
From: Bin Chen <bin.chen@linaro.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Everyone,

I need suggestions with regard to adding controls to query camera read
only parameters (e.g maxZoom/maxExposureCompensation) as needed by
Android Camera API[1].

What is in my mind is to add a customized camera control ID for each
parameter I want to query and return EACCES when being used wit
VIDIOC_S_EXT_CTRLS.

Or, I can port the compound controls [2] patch and then I only need to
add one customized control ID.

Comments? What is the better way to do this?

[1] http://developer.android.com/reference/android/hardware/Camera.Parameters.html
[2]http://comments.gmane.org/gmane.comp.video.linuxtv.scm/19545

-- 
Regards,
Bin
