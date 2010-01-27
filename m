Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:43978 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932220Ab0A0XZS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 18:25:18 -0500
Message-ID: <4B60CB5A.7000109@epfl.ch>
Date: Thu, 28 Jan 2010 00:25:14 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: [Q] udev and soc-camera
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a system that is built with OpenEmbedded where I use a mt9t031 
camera with the soc-camera framework. The mt9t031 works ok with the 
current kernel and system.

However, udev does not create the /dev/video0 device node. I have to 
create it manually with mknod and then it works well. If I unbind the 
device on the soc-camera bus (and then eventually rebind it), udev then 
creates the node correctly. This looks like a "timing" issue at "coldstart".

OpenEmbedded currently builds udev 141 and I am using kernel 2.6.33-rc5 
(but this was already like that with earlier kernels).

Is this problem something known or has at least someone already 
experienced that problem ?

Thanks and best regards

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEB3494, Station 9, CH-1015 Lausanne
