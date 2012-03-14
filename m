Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36993 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030218Ab2CNGS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 02:18:26 -0400
Received: by wejx9 with SMTP id x9so1314785wej.19
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2012 23:18:25 -0700 (PDT)
Date: Wed, 14 Mar 2012 07:10:37 +0100
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: nuvoton-cir on Intel DH67CL
Message-ID: <20120314071037.43f650e4@grobi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi !

I'm using above board which has a nuvoton-cir onboard (as most Intel
Media boards) - It shows itself as NTN0530. 

The remote function works without a problem (loaded RC6 MCE keytable). 

What doesn't work is wake from S3 and wake from S5. There are some
rumors that installing Windows 7 and corresponding drivers has a
positive effect (for some it seems to be enough to do it one time,
others need to redo this from time to time (power loss?). This leads me
to believe, that some hardware initialization is missing. 

I'm about to try latest linux-media tree next days, but i believe
there hasn't been any change on this driver. 

My questions: 
- any idea of what i should look at ?
- any change on the driver i could try ? 
- *IF* i go to install Win7 and drivers - anything i could to to help
  tracking down what this does in order to make the driver work out
  of the box on linux ?

As a lot of Sandy Bridge Boards to have this chip lately - it would
be nice if this could just work or is my impression, that this is a
general problem in this hardware wrong ?   
