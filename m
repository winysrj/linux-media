Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab2IIV6G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 17:58:06 -0400
Message-ID: <504D1133.2030408@redhat.com>
Date: Sun, 09 Sep 2012 23:59:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Subject: Re: [media] gspca: Fix locking issues related to suspend/resume
References: <20120719121355.GA2609@elgon.mountain>
In-Reply-To: <20120719121355.GA2609@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the report, it turns out that the checking for gspca_dev->dev,
rather then gspca_dev->present (which is a mod I made on top of
Hans Verkuil's orginal patch), turns out to be a bad idea in general
as its racy, this race has been fixed by this commit:
http://git.linuxtv.org/hgoede/gspca.git/commitdiff/a454f0811950742475b76dbf5ac10876e48ffaaa

Which should also appease the static checker warnings.

Thanks & Regards,

Hans


On 07/19/2012 02:13 PM, Dan Carpenter wrote:
> Hello Hans Verkuil,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 254902b01d2a: "[media] gspca: Fix locking issues related to
> suspend/resume" from May 6, 2012, leads to the following Smatch
> complaint:
>
> drivers/media/video/gspca/sq905c.c:176 sq905c_dostream()
> 	 warn: variable dereferenced before check 'gspca_dev->dev' (see line 180)
>
> drivers/media/video/gspca/sq905c.c
>     158                  /* Request the header, which tells the size to download */
>     159                  ret = usb_bulk_msg(gspca_dev->dev,
>     160                                  usb_rcvbulkpipe(gspca_dev->dev, 0x81),
>                                                          ^^^^^^^^^^^^^^
> Derereference inside the calls to usb_bulk_msg() and usb_rcvbulkpipe().
>
>     161                                  buffer, FRAME_HEADER_LEN, &act_len,
>     162                                  SQ905C_DATA_TIMEOUT);
>     163                  PDEBUG(D_STREAM,
>     164                          "Got %d bytes out of %d for header",
>     165                          act_len, FRAME_HEADER_LEN);
>     166                  if (ret < 0 || act_len < FRAME_HEADER_LEN)
>     167                          goto quit_stream;
>     168                  /* size is read from 4 bytes starting 0x40, little endian */
>     169                  bytes_left = buffer[0x40]|(buffer[0x41]<<8)|(buffer[0x42]<<16)
>     170                                          |(buffer[0x43]<<24);
>     171                  PDEBUG(D_STREAM, "bytes_left = 0x%x", bytes_left);
>     172                  /* We keep the header. It has other information, too. */
>     173                  packet_type = FIRST_PACKET;
>     174                  gspca_frame_add(gspca_dev, packet_type,
>     175                                  buffer, FRAME_HEADER_LEN);
>     176			while (bytes_left > 0 && gspca_dev->dev) {
>                                                   ^^^^^^^^^^^^^^
> New check.
>
>     177				data_len = bytes_left > SQ905C_MAX_TRANSFER ?
>     178					SQ905C_MAX_TRANSFER : bytes_left;
>     179				ret = usb_bulk_msg(gspca_dev->dev,
>     180					usb_rcvbulkpipe(gspca_dev->dev, 0x81),
>                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Some more dereferences here.
>
>     181					buffer, data_len, &act_len,
>     182					SQ905C_DATA_TIMEOUT);
>     183                          if (ret < 0 || act_len < data_len)
>     184                                  goto quit_stream;
>     185                          PDEBUG(D_STREAM,
>     186                                  "Got %d bytes out of %d for frame",
>     187                                  data_len, bytes_left);
>     188                          bytes_left -= data_len;
>     189                          if (bytes_left == 0)
>     190                                  packet_type = LAST_PACKET;
>     191                          else
>     192                                  packet_type = INTER_PACKET;
>     193                          gspca_frame_add(gspca_dev, packet_type,
>     194                                          buffer, data_len);
>     195                  }
>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
