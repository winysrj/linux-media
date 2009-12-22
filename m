Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:54889 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZLVRaa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 12:30:30 -0500
Received: by qyk30 with SMTP id 30so3053094qyk.33
        for <linux-media@vger.kernel.org>; Tue, 22 Dec 2009 09:30:29 -0800 (PST)
Message-ID: <4B310280.5090601@gmail.com>
Date: Tue, 22 Dec 2009 13:31:44 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: tt s2-3200: dvb-s2 problem transponders fixed :) concerns SR
 30000 3/4 8psk mode
References: <650504.20712.qm@web23208.mail.ird.yahoo.com>
In-Reply-To: <650504.20712.qm@web23208.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newsy Paper a écrit :
> thanks to Andreas Regel + Manu Abraham for their work.
>
> I just tested those problem transponders. If I set SR to 29998 instead of 30000 they finally work with recent s2-liplian changeset.
>
> Thank you for your great work and thanks to all the others involved in v4l driver development.
>   
Then I guess this is related to a computation being abit off (30000 is 
probably a threshold also).
I any case I still have to add 4MHz to the frequencies (with DVB-S) to 
get a reliable lock with tt s2-3200 (kernel is ubuntu 2.6.31.4)
Bye
Manu
