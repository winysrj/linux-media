Return-path: <linux-media-owner@vger.kernel.org>
Received: from rev-89-235-36-82.velbnet.cz ([89.235.36.82]:51705 "EHLO
	link-v.kaznejov.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZFGIxx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 04:53:53 -0400
Received: from localhost (localhost [127.0.0.1])
	by link-v.kaznejov.cz (Postfix) with ESMTP id A6287C0535
	for <linux-media@vger.kernel.org>; Sun,  7 Jun 2009 10:43:37 +0200 (CEST)
Received: from link-v.kaznejov.cz ([127.0.0.1])
	by localhost (kaznejov.cz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ROU7pdcXajtn for <linux-media@vger.kernel.org>;
	Sun,  7 Jun 2009 10:43:33 +0200 (CEST)
Received: from [192.168.62.2] (unknown [192.168.62.2])
	by link-v.kaznejov.cz (Postfix) with ESMTP id AA0EDCE3FB
	for <linux-media@vger.kernel.org>; Sun,  7 Jun 2009 10:43:33 +0200 (CEST)
Message-ID: <4A2B7DB4.2000802@kaznejov.cz>
Date: Sun, 07 Jun 2009 10:43:32 +0200
From: jirik <jirik@kaznejov.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV NOVA-S and DiseqC problem
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

It is not new problem, but because it is not fixed after 2.5 year, I 
must try to make focus to bugfix again.

Problem on isl6421 driver is two types of LNB current limitation. 
Default type of current limitation is not possible use in combination 
wit DiseqC.

Detail and patch for bug fix is here:
http://www.linuxtv.org/pipermail/linux-dvb/2006-November/014567.html

This patch is over 2.5year old, but still not integrated to sources. 
Problem is real, in DVBN forum exist many threads with this problem and 
when I try make google query for "isl6421 dcl linux", it will return 
pages where this patch is known (over 1300 pages). Pages without 
solution for this problem is little bit more.

Coul me somebody tell how to add this patch to official sources?

Jiri


