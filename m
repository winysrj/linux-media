Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out3.iol.cz ([194.228.2.91]:42861 "EHLO smtp-out3.iol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759120Ab1JFSoc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Oct 2011 14:44:32 -0400
Received: from antivir5.iol.cz (unknown [192.168.30.212])
	by smtp-out3.iol.cz (Postfix) with ESMTP id 0DDD9BC86C2
	for <linux-media@vger.kernel.org>; Thu,  6 Oct 2011 18:12:46 +0000 (UTC)
Received: from localhost (antivir5.iol.cz [127.0.0.1])
	by antivir5.iol.cz (Postfix) with ESMTP id E76151E80AC
	for <linux-media@vger.kernel.org>; Thu,  6 Oct 2011 20:12:45 +0200 (CEST)
Received: from antivir5.iol.cz ([127.0.0.1])
	by localhost (antivir5.iol.cz [127.0.0.1]) (amavisd-new, port 10224)
	with LMTP id VnTptGlVuzjc for <linux-media@vger.kernel.org>;
	Thu,  6 Oct 2011 20:12:45 +0200 (CEST)
Received: from port2.iol.cz (unknown [192.168.30.92])
	by antivir5.iol.cz (Postfix) with ESMTP id CCCD01E80A5
	for <linux-media@vger.kernel.org>; Thu,  6 Oct 2011 20:12:45 +0200 (CEST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-media@vger.kernel.org
Date: Thu, 06 Oct 2011 20:12:45 +0200
Subject: Arch Linux package names for media-build
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Donat" <michal.donat@atlas.cz>
Message-ID: <op.v2xzjjzd1s61x9@arch-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
see the console output below. The mentioned packages in Arch Linux are:

Digest::SHA1: repository/package = extra/perl-digest-sha1
Proc::ProcessTable: repository/package = aur/perl-proc-processtable
Also there was missing lsdiff: repository/package = community/patchutils


> /tmp/src $ git clone git://linuxtv.org/media_build.git
> /tmp/src/media_build $  
> ./build                                                                                                                            
> Checking if the needed tools for Arch Linux are  
> available                                                                                                                           
> ERROR: please install "Digest::SHA1", otherwise, build won't  
> work.                                                                                                                  
> ERROR: please install "Proc::ProcessTable", otherwise, build won't  
> work.                                                                                                            
> I don't know distro Arch Linux. So, I can't provide you a hint with the  
> package  
> names.                                                                                              
> Be welcome to contribute with a patch for media-build, by submitting a  
> distro-specific  
> hint                                                                                         
> to  
> linux-media@vger.kernel.org

-- 
Using Opera's revolutionary email client: http://www.opera.com/mail/
