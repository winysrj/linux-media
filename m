Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62802 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1KOSzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 13:55:18 -0500
Received: by ggnb2 with SMTP id b2so7781739ggn.19
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2011 10:55:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ec187a6.c6d0e30a.2cea.ffff9e85@mx.google.com>
References: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
	<CAB33W8eMEG6cxM9x0aGRe+1xx6TwvjBZL4KSdRY4Ti2sTHk9hg@mail.gmail.com>
	<CAL9G6WXq_MSu+6Ogjis43bsszDri0y5JQrhHrAQ8tiTKv09YKQ@mail.gmail.com>
	<CAATJ+ftr76OMckcpf_ceX4cPwv0840C9HL+UuHivAtub+OC+jw@mail.gmail.com>
	<4ebdacc2.04c6e30a.29e4.58ff@mx.google.com>
	<CAB33W8eYnQbKAkNobiez0yH5tgCVN4s84ncT5cmKHxeqHm8P3Q@mail.gmail.com>
	<CAL9G6WXHfA-n0u_yB7QvUAN_8TxSSA2M_O0m6kbsOrcgE+nMsA@mail.gmail.com>
	<CAB33W8cJYoXe+1yCPhEGgSpHM7AYd_b-sm5dSy8g+jT=98X=eg@mail.gmail.com>
	<CAB33W8eTZg3Q9xZg9Ebz5C+Cb_H2SHH_R1u30V4i+_Oe8N1ysA@mail.gmail.com>
	<4ec187a6.c6d0e30a.2cea.ffff9e85@mx.google.com>
Date: Tue, 15 Nov 2011 18:55:17 +0000
Message-ID: <CAB33W8drXJMcV9VB7_+09mwC_0YGZANHgxRkSN-c8KDo31=7qA@mail.gmail.com>
Subject: Re: AF9015 Dual tuner i2c write failures
From: Tim Draper <veehexx@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Are you sure that your system hasn't rolled to 2.6.38-13-generic
> yesterday or today even?
>
still on 2.6.38-12-generic. i've ensured auto-updates are disabled so
it should be in the same state as it when it was working.
worth re-applying the update/patch? i presume i just need to make &&
make install again...?
