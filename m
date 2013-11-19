Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:63666 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3KSVl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 16:41:58 -0500
Received: by mail-bk0-f51.google.com with SMTP id 6so1295608bkj.38
        for <linux-media@vger.kernel.org>; Tue, 19 Nov 2013 13:41:57 -0800 (PST)
Message-ID: <528BDB21.1010508@googlemail.com>
Date: Tue, 19 Nov 2013 22:41:53 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Alain VOLMAT <alain.volmat@st.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [v4l-utils] Fix configure.ac --disable-v4l-utils option
References: <E27519AE45311C49887BE8C438E68FAA013CA68BC8E0@SAFEX1MAIL1.st.com>
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA013CA68BC8E0@SAFEX1MAIL1.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/11/13 14:28, Alain VOLMAT wrote:
>
> When using AC_ARG_ENABLE with a string containing - in it, the variable created will contains a _ instead of the -.
> Thus for AC_ARG_ENABLE(v4l-utils ..., the variable enable_v4l_utils must be checked.

Applied, Thanks!

