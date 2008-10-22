Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ariken@gmail.com>) id 1KskkC-0006wZ-G7
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 22:55:53 +0200
Received: by fg-out-1718.google.com with SMTP id e21so430804fga.25
	for <linux-dvb@linuxtv.org>; Wed, 22 Oct 2008 13:55:49 -0700 (PDT)
Message-ID: <8d4787ed0810221355uc885265tfb9d4a82df05c7e6@mail.gmail.com>
Date: Wed, 22 Oct 2008 22:55:48 +0200
From: Ariken <ariken@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2723_6590601.1224708948898"
Subject: [linux-dvb] mantis and stb6100 RACK failed solved
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_2723_6590601.1224708948898
Content-Type: multipart/alternative;
	boundary="----=_Part_2724_8355428.1224708948898"

------=_Part_2724_8355428.1224708948898
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is a patch for http://mercurial.intuxication.org/hg/s2-liplianin

mantis:
added SKYSTAR HD2 with 0x03 device id.
02:0d.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0003

stb6100:
*mantis_ack_wait* (*0*): *Slave RACK Fail*
The I2C Repeater must enabled to communicate with the stb6100 via 0x60.


Andrea

------=_Part_2724_8355428.1224708948898
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is a patch for <a href="http://mercurial.intuxication.org/hg/s2-liplianin" target="_blank">http://mercurial.intuxication.org/hg/s2-liplianin</a><br><br>mantis: <br>added SKYSTAR HD2 with 0x03 device id.<br>02:0d.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev 01)<br>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Device 1ae4:0003<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>stb6100:<br><i>mantis_ack_wait</i> (<i>0</i>): <i>Slave RACK Fail</i> <br>The I2C Repeater must enabled to communicate with the stb6100 via 0x60.<br><br><br>Andrea

------=_Part_2724_8355428.1224708948898--

------=_Part_2723_6590601.1224708948898
Content-Type: application/x-gzip; name=stb6100.diff.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmmg19vo0
Content-Disposition: attachment; filename=stb6100.diff.gz

H4sICJqF/0gAA3N0YjYxMDAuZGlmZgDVV1tv2koQfoZfMaJKhLEJaxsIlzYnF0gTtSVVIKmOomhl
7DWxAob6ktIe9b+f2bXXkIZcUJL2HB6wvTs7+818M7Ozjue6UA7AYPXtYcNuVO0qg7Hnx/OKE3g3
LAgrE+Z4VsW5GVbcYOpHzHfCShgN6zohW3a+XC6DVVljRW4QMzixIzB0MMwWMVo1AwxCGqASk5C8
qqowXEvhF+YkClGP3qrVWwaRCvGR392FsmEQTccB/jRqsLubh3/ykPP8CAK7jW9hFMSoIlVKw8iK
GJSSxztwWXknin0W0BkiaufVnOdCkY9OZ+GWZ9h0hILUjoKxklfhnt9KedSiga4gBo4HtRYDG3eU
QAJmOfg3KgooGvQH+2L8Y0dR4C0QBVflAhbFgS8seWlkJEWWbsHBbS6BoB9PDj4o8BcMznrdU9of
7A3O+mKw24EWEFz8M69yDRy/ZwP3uLRtxCI6tHznm+dEV8WUASSZSpKhxCHEpgGlTE75lbm4Ae7/
kcHD1QSKaK3qWh2DtdrQmiJWUWbhAaEbVZV3VgzxRxxuLWZKgJtxHnIOWu5H10XMqOE0RCSHXdrp
7p+9R/QaFJaVbcRw9KOg3dlHeZ0AUxcBlkQMpG5oCjfUmlpDuCHHQyGazNr/wdR9xLshi2Dh4Wia
uXjZt6nZ2wn7DVOaPQnHjM2KYqsVEfYt8BDRqhA7OPiAHp4T548Ui4RLYVLDECY169IkTt8sdAwN
pg6nZV0aRd6jyeGFNLZ39um0+75/+SdyO5Se5+8P5DXaj24wdSPN64ejhmsouAH7GjPf/p6k5fXR
j8Rl4lMTPkxf3XlkjZek3Bt7uvTZKx4rqWSveJi8FsQeaZZnOyUbaCk/6WzAXBbgLNNyXLEGPgLH
fzew7N9bFkx9W3jRrGs6WdSFMEgihSSW3wL4cLyIuZF2Kx7VV4ki9WXiqKpXuQeq5rZMp2UJWFQM
k7wSNSuzvNpscFg1w5ThLc/06CY70zF/pzMWRB4LocR9sMl34hLpxHdqW/YVay/TipTK4OR7vxI1
t7Riwc4QweZmtnq0NK6IVuSx0v8eS/+h7GhmVmBNWIRNbUFU89xyfttLSZgwXdPFWVAzm4tOIKuQ
iCQTF3ZkX0r7F7lFm8XlhE+VdqUE0yDNmxIY2MWVKq8Q+CvjxVnn3jGx/MgL0we1pwF79OKxasnz
bh4rNT7h6tHUtW1Q8V+maqKhvHP1zZ76rjfiOXAz04lZpZlyPi7CY4il4Zq/2VbI4NNeb3Dcp+ef
qU6qOu2c79O+0cpVKnD+ucyH8uVEcNA9OOod9/cGtP/hb+zKT+lRx2ghtffPUv2ReVz/AHqE83T0
BjFNgf5AgucjzwkKHFkzJsSKlwyJROGTLqNNHhL8IWPi51O5/n0Euyw5oEij2aRWFGFRLkqmE4o1
2JTClmPNsKglJY2Xj4WWtEjerZKpgd3T05NT0e48g36sOmvSL1a8JP2JwqcUBNEE4v+2rOj3uea4
d3ii8YamIKvsRtiCPccJWBi+uyDzDWLML+Htl50LSFo5St3YtynVYBKOOC1OIDqASkWQIsfgHfZJ
8zpRQOzv4jFQ9Hjv1AYPmw4hN2Y+fqnqfYfcHYwcDMJIVg9j98K7xL2fQWoSbFtXa/EqF70ktZnO
pyR3Q+S2vLm/8Xx7HDsMCmN/ODNQSYG7/I3DXM+/J8lzeGMjJtZyKbUyXYUU0fPqg1JUz+Sw0Pbj
Yfg9jNikBR1249kMdItVWzhvPqbHAKHH5OjZHHPdh7S7S52UHQj3nAa3F8nCcnuNFP4XKqdVGJYU
AAA=
------=_Part_2723_6590601.1224708948898
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_2723_6590601.1224708948898--
