Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59089 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1JMMsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 08:48:54 -0400
Received: by bkbzt4 with SMTP id zt4so1391457bkb.19
        for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 05:48:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E967E5B.3050504@lockie.ca>
References: <4E967E5B.3050504@lockie.ca>
Date: Thu, 13 Oct 2011 08:48:52 -0400
Message-ID: <CAGoCfiyViRDt690TWtiWdnfP5C-az2aeOK=TGhgP4kwT1QJfqQ@mail.gmail.com>
Subject: Re: recent cx23385?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2011 at 1:59 AM, James <bjlockie@lockie.ca> wrote:
> Is there a newer cx23385 driver than the one in kernel-3.0.4?
> I bought a http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1250 and it
> shows video for about 5 seconds and then locks up the system.

You cannot install individual drivers (Linux doesn't work like Windows
in this regards).  You have to either install the latest kernel or you
can swap out the whole media subsystem with a later version.

http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
