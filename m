Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QIX3ma030370
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 13:33:03 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1QIWQFP014333
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 13:32:26 -0500
Date: Tue, 26 Feb 2008 19:32:03 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Michel Bardiaux <mbardiaux@mediaxim.be>
Message-ID: <20080226183202.GA787@daniel.bse>
References: <47C3F5CB.1010707@mediaxim.be> <20080226130200.GA215@daniel.bse>
	<20080226133839.GE26389@devserv.devel.redhat.com>
	<47C440FB.8080705@mediaxim.be>
	<20080226170215.GB4682@devserv.devel.redhat.com>
	<47C4488A.8080107@mediaxim.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C4488A.8080107@mediaxim.be>
Cc: video4linux-list@redhat.com
Subject: Re: Grabbing 4:3 and 16:9
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, Feb 26, 2008 at 06:12:42PM +0100, Michel Bardiaux wrote:
> As I find more relevant pages, my question has now become: given a 
> 768x576 capture (by a BT878) can I check whether the PALPLUS is there?

WSS is in the first line of the 576 line picture.
One of the bits says if there is PALplus.

WSS standard:
http://webapp.etsi.org/WorkProgram/Report_WorkItem.asp?WKI_ID=16170

PALplus standard:
http://webapp.etsi.org/workprogram/Report_WorkItem.asp?WKI_ID=3850

You can use libzvbi to decode the information:

vbi_raw_decoder_init(&vbi_rd);
vbi_rd.scanning = 625;
vbi_rd.sampling_format = VBI_PIXFMT_YUYV;
vbi_rd.sampling_rate = 13500000.0*width/702;
vbi_rd.offset = 186*width/924;
vbi_rd.bytes_per_line = width*2;
vbi_rd.start[0] = 23;
vbi_rd.count[0] = 1;
vbi_rd.start[1] = 0;
vbi_rd.count[1] = 0;
vbi_rd.interlaced = 0;
vbi_rd.synchronous = 1;
vbi_raw_decoder_add_services(&vbi_rd,VBI_SLICED_WSS_625,0);
while(framebuf=grabpicture()) {
  vbi_sliced sliced;
  if(vbi_raw_decode (&vbi_rd, framebuf, &sliced)
     && sliced.id==VBI_SLICED_WSS_625)
  {
    wss=(sliced.data[1]<<8)+sliced.data[0];
    if(wss&64) {
      /* There is PALplus
      
         I have seen the decoder generate false positives.
	 Check aspect ratio bits for >=16:9 and their odd parity bit
	 to be shure. */
    }
  }
}

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
