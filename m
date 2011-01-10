Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:42283 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab1AJBtJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jan 2011 20:49:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Pc6se-0001db-EV
	for linux-media@vger.kernel.org; Mon, 10 Jan 2011 02:49:08 +0100
Received: from 154.139.70.115.static.exetel.com.au ([115.70.139.154])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 02:49:08 +0100
Received: from 0123peter by 154.139.70.115.static.exetel.com.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 02:49:08 +0100
To: linux-media@vger.kernel.org
From: "Peter D." <0123peter@gmail.com>
Subject: Re: [patch] new_build.git - avoid failing on 'rm' of nonexistent file
Date: Mon, 10 Jan 2011 12:48:09 +1100
Message-ID: <q35qv7-94q.ln1@psd.motzarella.org>
References: <AANLkTinUVpHdJRZ_EHw8B4nv=X2yNoOwdNqtH_+wiV=r@mail.gmail.com> <6B50A1B6-ED80-46CB-996F-86F4F1BF4C35@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

on Sat, 8 Jan 2011 03:23
in the Usenet newsgroup gmane.linux.drivers.video-input-infrastructure
Jarod Wilson wrote:

> On Jan 7, 2011, at 6:53 AM, Vincent McIntyre wrote:
> 
>> While attempting to build recently I have found the 'make distclean'
>> target fails if 'rm' tries to remove a file that is not there. The
>> attached patch fixes the issue for me (by using rm -f).
>> I converted all the other 'rm' calls to 'rm -f' along the way.
>> 
>> Please consider applying this.
> 
> Yeah, I did the same earlier for another target, I'll go ahead and 
get
> it applied and pushed.

Third attempt to post to this news group...  

The --force option stops complaints about non existent files 
AND removes read only files.  If that is what you want, then fine.  
If you are only trying to stop existence problems, test for 
existence before removing.  

-- 
Peter D.  
Sig goes here...  

