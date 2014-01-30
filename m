Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:49831 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbaA3TAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 14:00:49 -0500
Date: Thu, 30 Jan 2014 20:01:08 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] gspca - topro: New subdriver for Topro webcams
Message-ID: <20140130200108.6d13a7f1@armhf>
In-Reply-To: <20140130121408.GB17753@elgon.mountain>
References: <20140130121408.GB17753@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Jan 2014 15:14:09 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> Hello Jean-François Moine,
> 
> The patch 8f12b1ab2fac: "[media] gspca - topro: New subdriver for
> Topro webcams" from Sep 22, 2011, leads to the following
> static checker warning:
> 	drivers/media/usb/gspca/topro.c:4642
> 	sd_pkt_scan() warn: check 'data[]' for negative offsets s32min"
> 
> drivers/media/usb/gspca/topro.c
>   4632                  data++;
> 
> Should there be an "if (len < 8) return;" here?
> 
>   4633                  len--;
>   4634                  if (*data == 0xff && data[1] == 0xd8) {
>   4635  /*fixme: there may be information in the 4 high bits*/
>   4636                          if ((data[6] & 0x0f) != sd->quality)
>   4637                                  set_dqt(gspca_dev, data[6] & 0x0f);
>   4638                          gspca_frame_add(gspca_dev, FIRST_PACKET,
>   4639                                          sd->jpeg_hdr, JPEG_HDR_SZ);
>   4640                          gspca_frame_add(gspca_dev, INTER_PACKET,
>   4641                                          data + 7, len - 7);
>   4642                  } else if (data[len - 2] == 0xff && data[len - 1] == 0xd9) {
>   4643                          gspca_frame_add(gspca_dev, LAST_PACKET,
>   4644                                          data, len);
>   4645                  } else {
>   4646                          gspca_frame_add(gspca_dev, INTER_PACKET,
>   4647                                          data, len);
>   4648                  }
>   4649                  return;
>   4650          }
>   4651  
>   4652          switch (*data) {
>   4653          case 0x55:
>   4654                  gspca_frame_add(gspca_dev, LAST_PACKET, data, 0);
>   4655  
>   4656                  if (len < 8
>                             ^^^^^^^
> The same as there is here.
> 
>   4657                   || data[1] != 0xff || data[2] != 0xd8
>   4658                   || data[3] != 0xff || data[4] != 0xfe) {
>   4659  
>   4660                          /* Have only seen this with corrupt frames */
>   4661                          gspca_dev->last_packet_type = DISCARD_PACKET;
>   4662                          return;
>   4663                  }
>   4664                  if (data[7] != sd->quality)
>   4665                          set_dqt(gspca_dev, data[7]);
>   4666                  gspca_frame_add(gspca_dev, FIRST_PACKET,
>   4667                                  sd->jpeg_hdr, JPEG_HDR_SZ);
>   4668                  gspca_frame_add(gspca_dev, INTER_PACKET,
>   4669                                  data + 8, len - 8);
>   4670                  break;
>   4671          case 0xaa:
>   4672                  gspca_dev->last_packet_type = DISCARD_PACKET;
>   4673                  break;
>   4674          case 0xcc:
> 
> I suppose we could add a "if (len < 1)" here as well.
> 
>   4675                  if (data[1] != 0xff || data[2] != 0xd8)
>   4676                          gspca_frame_add(gspca_dev, INTER_PACKET,
>   4677                                          data + 1, len - 1);
>   4678                  else
>   4679                          gspca_dev->last_packet_type = DISCARD_PACKET;
>   4680                  break;
>   4681          }
>   4682  }

AFAIR, there should be no bug because:

- for the BRIDGE_TP6810
	- no, there shoud not be a "if (len < 8) return;" at the place
	  you put it: the end of image may be indicated by just 0x5a,
	  0xff, 0xd9.

	- when the first byte is 0x5a, there are always at least 3
	  bytes.

	- when the 2nd and 3rd bytes are 0xff, 0xd8, there are always at
	  least 8 bytes. I never saw corrupt packets.

- for the BRIDGE_TP6800
	- when the first byte is 0x55 (start of image), I saw some
	  corrupt packets with less than 8 bytes. So, the test is there.

	- when the first byte is 0xcc, it is an intermediate packet, so
	  it always contains some data. I never saw such packets
	  reduced to less than 3 bytes. 

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
