Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:39599 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZCRN1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 09:27:04 -0400
Received: by yx-out-2324.google.com with SMTP id 31so49692yxl.1
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2009 06:27:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <004b01c9a79e$db8d4630$0a00a8c0@vorg>
References: <000701c9a5de$09033e20$0a00a8c0@vorg>
	 <49BE5B36.1080901@linuxtv.org> <004b01c9a79e$db8d4630$0a00a8c0@vorg>
Date: Wed, 18 Mar 2009 09:27:02 -0400
Message-ID: <de8cad4d0903180627g27ce9e68v8b0c3c4943f2c78c@mail.gmail.com>
Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 18, 2009 at 3:51 AM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
> Anyone know how to get the crash data to a log file? A way to redirect main monitor to an ssh client or second linux computer
> through serial port and null modem cable?
>

See the Documentation/serial-console.txt file in your kernel source tree.
