Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37758 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdGZSfH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 14:35:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id t138so2057468wmt.4
        for <linux-media@vger.kernel.org>; Wed, 26 Jul 2017 11:35:06 -0700 (PDT)
Subject: Re: [PATCH v2] Build libv4lconvert helper support only when fork() is
 available.
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        Christophe Priouzeau <christophe.priouzeau@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
References: <1501073484-9193-1-git-send-email-hugues.fruchet@st.com>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <0a70a086-1c1d-05f8-8855-b25e88ddc06e@googlemail.com>
Date: Wed, 26 Jul 2017 20:35:01 +0200
MIME-Version: 1.0
In-Reply-To: <1501073484-9193-1-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7/26/17 2:51 PM, Hugues Fruchet wrote:
> Build libv4lconvert helper support only when fork() is available.
> This fix the build issue reported here:
> http://autobuild.buildroot.net/results/7e8/7e8fbd99a8c091d7bbeedd16066297682bbe29fe/build-end.log
> 
> More details on buildroot mailing list here:
> http://lists.buildroot.org/pipermail/buildroot/2017-July/199093.html

Applied. Thanks!
