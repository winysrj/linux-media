Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:55162 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZH3IUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 04:20:36 -0400
Message-ID: <4A9A3650.3000106@freemail.hu>
Date: Sun, 30 Aug 2009 10:20:32 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
CC: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: problem building v4l2-spec from docbook source
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I get the source from http://linuxtv.org/hg/v4l-dvb repository and I am now
at version 12564:6f58a5d8c7c6. When I try to build the human readable version
of the V4L2 specification I get some error message:

$ make v4l2-spec
[...]
Using catalogs: /etc/sgml/catalog
Using stylesheet: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/custom.dsl#html
Working on: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:1:55:W: cannot generate system identifier for public text "-//OASIS//DTD DocBook V3.1//EN"
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:23:0:E: reference to entity "BOOK" for which no system identifier could be generated
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:1:0: entity was defined here
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:23:0:E: DTD did not contain element declaration for document type name
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:25:9:E: there is no attribute "ID"
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:25:19:E: element "BOOK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:26:11:E: element "BOOKINFO" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:27:10:E: element "TITLE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:28:13:E: element "SUBTITLE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:30:16:E: element "AUTHORGROUP" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:31:13:E: element "AUTHOR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:32:11:E: element "FIRSTNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:33:9:E: element "SURNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:34:17:E: there is no attribute "ROLE"
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:34:21:E: element "OTHERNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:35:13:E: element "AFFILIATION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:36:11:E: element "ADDRESS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:37:11:E: element "EMAIL" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:42:13:E: element "AUTHOR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:43:11:E: element "FIRSTNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:44:9:E: element "SURNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:51:9:E: element "CONTRIB" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:55:13:E: element "AUTHOR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:56:11:E: element "FIRSTNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:57:9:E: element "SURNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:58:9:E: element "CONTRIB" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:61:13:E: element "AFFILIATION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:62:11:E: element "ADDRESS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:63:11:E: element "EMAIL" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:68:13:E: element "AUTHOR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:69:11:E: element "FIRSTNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:70:9:E: element "SURNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:77:9:E: element "CONTRIB" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:81:13:E: element "AUTHOR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:82:11:E: element "FIRSTNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:83:9:E: element "SURNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:84:9:E: element "CONTRIB" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:87:13:E: element "AFFILIATION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:88:11:E: element "ADDRESS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:89:11:E: element "EMAIL" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:95:13:E: element "AUTHOR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:96:11:E: element "FIRSTNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:97:9:E: element "SURNAME" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:98:9:E: element "CONTRIB" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:100:13:E: element "AFFILIATION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:101:11:E: element "ADDRESS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:102:11:E: element "EMAIL" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:107:14:E: element "COPYRIGHT" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:108:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:109:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:110:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:111:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:112:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:113:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:114:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:115:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:116:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:117:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:118:11:E: element "YEAR" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:119:13:E: element "HOLDER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:123:16:E: element "LEGALNOTICE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:124:11:E: element "PARA" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:124:42:W: cannot generate system identifier for general entity "copy"
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:124:42:E: general entity "copy" not defined and no default entity
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:124:46:E: reference to entity "copy" for which no system identifier could be generated
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:124:41: entity was defined here
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:128:11:E: element "PARA" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:135:11:E: element "PARA" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:139:15:E: element "REVHISTORY" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:146:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:147:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:148:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:149:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:150:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:153:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:154:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:155:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:156:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:157:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:160:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:161:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:162:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:163:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:164:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:167:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:168:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:169:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:170:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:171:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:175:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:176:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:177:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:178:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:179:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:185:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:186:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:187:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:188:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:189:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:193:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:194:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:195:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:196:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:197:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:201:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:202:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:203:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:204:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:205:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:214:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:215:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:216:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:217:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:218:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:221:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:222:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:223:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:224:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:225:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:229:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:230:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:231:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:232:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:233:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:236:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:237:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:238:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:239:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:240:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:244:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:245:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:246:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:247:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:248:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:251:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:252:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:253:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:254:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:255:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:259:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:260:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:261:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:262:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:263:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:270:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:271:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:272:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:273:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:274:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:279:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:280:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:281:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:282:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:283:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:288:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:289:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:290:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:291:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:292:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:296:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:297:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:298:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:299:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:300:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:304:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:305:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:306:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:307:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:308:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:312:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:313:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:314:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:315:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:316:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:322:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:323:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:324:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:325:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:326:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:330:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:331:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:332:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:333:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:334:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:339:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:340:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:341:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:342:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:343:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:347:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:348:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:349:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:350:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:351:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:354:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:355:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:356:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:357:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:358:11:E: element "REVREMARK" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:363:15:E: element "REVISION" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:364:11:E: element "REVNUMBER" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:365:6:E: element "DATE" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:366:16:E: element "AUTHORINITIALS" undefined
openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:367:11:E: element "REVREMARK" undefined
openjade:I: maximum number of errors (200) reached; change with -E option
make[2]: *** [html-single-build.stamp] Error 8
make[2]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l2-spec'
make[1]: *** [v4l2-spec] Error 2
make[1]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l'
make: *** [v4l2-spec] Error 2

I am running Debian 5.0 with docbook-utils package version 0.6.14-1.1.
Any idea how to fix this?

Regards,

	Márton Németh
