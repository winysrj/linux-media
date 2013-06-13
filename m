Return-path: <linux-media-owner@vger.kernel.org>
Received: from c2bthomr09.btconnect.com ([213.123.20.127]:14905 "EHLO
	mail.btconnect.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994Ab3FMP62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 11:58:28 -0400
Message-ID: <51B9EB45.1050004@peepo.com>
Date: Thu, 13 Jun 2013 16:54:45 +0100
From: Jonathan Chetwynd <jay@peepo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: is there a user mailing list?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the developer list is very busy...

I'm successfully using mmap but now wish to improve my understanding...

in particular how to get the values of a frame in the buffer?

write(STDOUT_FILENO, buffers[buf.index].start, Buffersize); sends one 
frame from the buffer to stdout

what would be the syntax to iterate through that frame of the buffer?
ie to get each of the 0-255 values for a frame

regards

-- 
Jonathan Chetwynd
http://www.gnote.org
Eyetracking in HTML5

