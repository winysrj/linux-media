Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1G9ZEdA020730
	for <video4linux-list@redhat.com>; Tue, 16 Feb 2010 04:35:14 -0500
Received: from snt0-omc3-s34.snt0.hotmail.com (snt0-omc3-s34.snt0.hotmail.com
	[65.55.90.173])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1G9Z2YK030954
	for <video4linux-list@redhat.com>; Tue, 16 Feb 2010 04:35:02 -0500
Message-ID: <SNT123-W319FE48E43DBE7AB84F1C9EE490@phx.gbl>
From: "Owen O' Hehir" <oo_hehir@hotmail.com>
To: <video4linux-list@redhat.com>
Subject: FW: Error in V4L2 API Spec Chapter 2.2 Rev 0.24??
Date: Tue, 16 Feb 2010 09:35:02 +0000
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


 Hello All,

I've been using your V4L2 API spec and think I've come across an error you may wish to know about. Its the conversion routine from YCbCr -> RGB (Inverse Transformation) Chapter 2.2. As far as I can make out there's no need for the multiplying by 255 at the end. I've run both functions back to back and the image is only correct when these are removed. (Highlighted below).

Regards,

Owen


int Y1, Cb, Cr;         /* gamma pre-corrected input [0;255] */
int ER, EG, EB;         /* output [0;255] */

double r, g, b;         /* temporaries */
double y1, pb, pr;

int
clamp (double x)
{
        int r = x;      /* round to nearest */

        if (r < 0)         return 0;
        else if (r > 255)  return 255;
        else               return r;
}

y1 = (255 / 219.0) * (Y1 - 16);
pb = (255 / 224.0) * (Cb - 128);
pr = (255 / 224.0) * (Cr - 128);

r = 1.0 * y1 + 0     * pb + 1.402 * pr;
g = 1.0 * y1 - 0.344 * pb - 0.714 * pr;
b = 1.0 * y1 + 1.772 * pb + 0     * pr;

ER = clamp (r * 255); /* [ok? one should prob. limit y1,pb,pr] */
EG = clamp (g * 255);
EB = clamp (b * 255);
 		 	   		  
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
https://signup.live.com/signup.aspx?id=60969
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
