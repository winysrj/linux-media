Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id o9RFUmbc002158
	for <video4linux-list@redhat.com>; Wed, 27 Oct 2010 11:30:48 -0400
Received: from mail-fx0-f46.google.com (mail-fx0-f46.google.com
	[209.85.161.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9RFUb38032147
	for <video4linux-list@redhat.com>; Wed, 27 Oct 2010 11:30:37 -0400
Received: by fxm16 with SMTP id 16so795198fxm.33
	for <video4linux-list@redhat.com>; Wed, 27 Oct 2010 08:30:36 -0700 (PDT)
Message-ID: <4CC84596.2000704@gmail.com>
Date: Wed, 27 Oct 2010 18:30:30 +0300
From: Alex Ivasyuv <industral@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: V4L2 capture example, gray color
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi,

I've tried to use sample code example from 
http://v4l2spec.bytesex.org/spec/capture-example.html
and save frame data to image, and found, that images are *gray* instead 
of color.

#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

int i = 0;

.....

static void process_image(const void * p) {
     ++i;
     fputc('.', stdout);
     fflush(stdout);

     std::stringstream out;
     out << "capt-" << i << ".raw";

     ofstream outfile(out.str().c_str(), ofstream::binary);
     outfile.write((const char*) p, buffers[0].length);
     outfile.close();
}

....

Raw images I converted with "raw2tiff" application.

lspci: http://pastebin.com/raw.php?i=VVL8m2Gu
my code: http://pastebin.com/R3j3LL96

What' wrong with my code? Why I get in gray, instead of color?

Thanks,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
