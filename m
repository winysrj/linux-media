Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:57795 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbZEOWRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 18:17:43 -0400
Date: Fri, 15 May 2009 17:31:30 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Preliminary results with an SN9C2028 camera
In-Reply-To: <200904160014.32558.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0905151715210.12530@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu> <49AE3EA1.3090504@kaiser-linux.li> <200904160014.32558.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I decided recently to work on support for the SN9C2028 dual-mode cameras, 
which are supported as still cameras in libgphoto2/camlibs/sonix. Today, I 
succeeded in getting three frames out of one of them, using svv -gr, and I 
was able to convert two of the three frames to nice images using the same 
decompression algorithm which is used for the cameras in stillcam mode.

There is a lot of work to do yet: support for all appropriate resolution 
settings (which are what? I do not yet know), support for all known 
cameras for which I can chase down an owner, and incorporation of the 
decompression code in libv4l.

However, I thought you might like to know that some success has been 
achieved.

As regards "all known cameras" I have tried unsuccessfully to contact the 
owner of a Genius Smart 300. It is sold in Europe, not over here, and the 
only person I know who had one has not answered my request for further 
information. I suspect the reason for that is his old e-mail is no longer 
valid; he was a student from Armenia studying in Switzerland and may have 
gone home now. So, I ask the question of the list. Does anyone know an 
owner of a Genius Smart 300 and can get for me a USB snoop of it starting 
up to do streaming?

Theodore Kilgore

