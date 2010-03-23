Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:44801 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0CWWsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 18:48:16 -0400
Received: by fxm23 with SMTP id 23so2726182fxm.1
        for <linux-media@vger.kernel.org>; Tue, 23 Mar 2010 15:48:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197381003231348h5c09c76av1adfbf7f13df10a1@mail.gmail.com>
References: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com>
	 <829197381003231348h5c09c76av1adfbf7f13df10a1@mail.gmail.com>
Date: Tue, 23 Mar 2010 19:48:14 -0300
Message-ID: <499b283a1003231548pd7bc1e7h56a8b97ad5682a44@mail.gmail.com>
Subject: Re: [PATCH] Fix Warning ISO C90 forbids mixed declarations and code -
	cx88-dvb
From: Ricardo Maraschini <xrmarsx@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 23, 2010 at 5:48 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> How do you think this actually addresses the warning in question?  You
> still have the declaration of the variable in the middle of the switch
> statement.

My mistake, sorry. I'm working on it.
Thanks for your tip, I really appreciate that.

-rm
